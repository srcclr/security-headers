module Headlines
  class FavouriteDomainsController < ApplicationController
    skip_before_action :redirect_to_login_if_required
    before_action :ensure_logged_in

    respond_to :html, :json

    def index
      respond_to do |format|
        format.html do
          store_preloaded("favourite_domains", MultiJson.dump(favourite_domains_as_json))
          render "default/empty"
        end

        format.json { render(json: favourite_domains_as_json) }
      end
    end

    def create
      favourite_domain = FavouriteDomain.find_or_create_by!(url: favourite_domain_params[:url])
      notification = current_user.favourite_domain_notifications.create!(favourite_domain: favourite_domain)
      render json: favourite_domain
    end

    def destroy
      status = favourite_domain_notification && favourite_domain_notification.destroy ? :ok : :not_found
      favourite_domain.destroy if favourite_domain_notifications.empty?

      head status
    end

    private

    def favourite_domain
      @favourite_domain ||= favourite_domains.find_by(id: params[:id])
    end

    def favourite_domain_notifications
      favourite_domain.email_notifications
    end

    def favourite_domain_notification
      @favourite_domain_notification ||= favourite_domain.email_notifications.find_by(user_id: current_user.id)
    end

    def favourite_domains_as_json
      serialize_data(favourite_domains, FavouriteDomainSerializer)
    end

    def favourite_domains
      @favourite_domains ||= current_user.favourite_domains
    end

    def favourite_domain_params
      params.require(:favourite_domain).permit(:url)
    end
  end
end
