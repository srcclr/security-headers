module Headlines
  class EmailNotificationsController < ApplicationController
    skip_before_action :redirect_to_login_if_required
    before_action :ensure_logged_in

    respond_to :json

    def update
      email_notification.update(notification_type: params[:notification_type])

      render json: email_notification
    end

    private

    def email_notification
      @email_notification ||= current_user
                              .favorite_domain_notifications
                              .find_by(favorite_domain_id: params[:favorite_domain_id])
    end
  end
end
