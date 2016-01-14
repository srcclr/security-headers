module Headlines
  class EmailNotification < ActiveRecord::Base
    belongs_to :favorite_domain
    belongs_to :user
  end
end
