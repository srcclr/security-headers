module Headlines
  class FavoriteDomain < ActiveRecord::Base
    has_many :email_notifications
  end
end
