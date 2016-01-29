module Headlines
  class FavoriteDomainsController < ApplicationController
    skip_before_action :redirect_to_login_if_required
    before_action :ensure_logged_in, only: %i(create destroy)

    respond_to :html, :json

    def index
      respond_to do |format|
        format.html do
          store_preloaded("favorite_domains", MultiJson.dump(favorite_domains_as_json))
          render "default/empty"
        end

        format.json { render(json: favorite_domains_as_json) }
      end
    end

    def create
      favorite_domain = FavoriteDomain.find_or_create_by!(url: favorite_domain_params[:url])
      notification = current_user.favorite_domain_notifications.create!(favorite_domain: favorite_domain)
      render json: favorite_domain
    end

    def destroy
      status = favorite_domain_notification && favorite_domain_notification.destroy ? :ok : :not_found
      favorite_domain.destroy if favorite_domain_notifications.empty?

      head status
    end

    private

    def favorite_domain
      @favorite_domain ||= favorite_domains.find_by(id: params[:id])
    end

    def favorite_domain_notifications
      favorite_domain.email_notifications
    end

    def favorite_domain_notification
      @favorite_domain_notification ||= favorite_domain.email_notifications.find_by(user_id: current_user.id)
    end

    def favorite_domains_as_json
      serialize_data(favorite_domains, FavoriteDomainSerializer)
    end

    def favorite_domains
      return FavoriteDomain.none unless current_user

      current_user.favorite_domains
    end

    def favorite_domain_params
      params.require(:favorite_domain).permit(:url)
    end
  end
end
