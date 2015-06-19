module Headlines
  class IndustryRankedDomain < ActiveRecord::Base
    self.primary_key = "id"

    belongs_to :category
    has_one :scan, foreign_key: :domain_id

    delegate :results, to: :scan, prefix: true
  end
end
