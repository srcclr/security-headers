module Headlines
  class FavouriteDomain < ActiveRecord::Base
    has_many :email_notifications
  end
end
