module Headlines
  class DomainsCategory < ActiveRecord::Base
    belongs_to :domain, foreign_key: :domain_name, primary_key: :name
    belongs_to :category
  end
end
