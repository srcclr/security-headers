module Headlines
  class DomainRankedByCategory < ActiveRecord::Base
    belongs_to :category
  end
end
