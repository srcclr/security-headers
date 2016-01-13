User.class_eval do
  has_many :favourite_domains,
           -> { order(:name) },
           through: :favourite_domain_notifications,
           class_name: "Headlines::FavouriteDomain"
  has_many :favourite_domain_notifications, class_name: "Headlines::EmailNotification"
end
