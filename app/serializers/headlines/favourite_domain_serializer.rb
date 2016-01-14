module Headlines
  class FavouriteDomainSerializer < ActiveModel::Serializer
    attributes :id, :url, :notification_type

    private

    def notification_type
      object.email_notifications.find_by(user: options[:scope].user).notification_type
    end
  end
end
