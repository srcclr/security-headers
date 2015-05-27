module Headlines
  class DomainsCategory < ActiveRecord::Base
    belongs_to :domain
    belongs_to :category
  end
end
