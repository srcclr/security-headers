module Headlines
  class Domain < ActiveRecord::Base
    validates :name, presence: true

    has_many :scans
  end
end
