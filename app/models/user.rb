User.class_eval do
  has_many :favorite_domains,
           -> { order(:url) },
           through: :favorite_domain_notifications,
           class_name: "Headlines::FavoriteDomain"
  has_many :favorite_domain_notifications, class_name: "Headlines::EmailNotification"
end
