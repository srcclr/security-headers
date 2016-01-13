module Headlines
  class EmailNotification < ActiveRecord::Base
    belongs_to :favourite_domain
    belongs_to :user
  end
end
