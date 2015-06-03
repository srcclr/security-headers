module Headlines
  class Scan < ActiveRecord::Base
    belongs_to :domain
  end
end
