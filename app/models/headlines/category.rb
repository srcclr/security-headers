module Headlines
  class Category < ActiveRecord::Base
    belongs_to :industry

    has_many :domains_categories
    has_many :domains, through: :domains_categories
    has_many :domains_ranked, class_name: "DomainRankedByCategory"
  end
end
