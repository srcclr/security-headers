module Headlines
  class Category < ActiveRecord::Base
    has_many :domains_categories
    has_many :domains, through: :domains_categories
    has_many :domains_ranked, class_name: "DomainRankedByCategory"
  end
end
