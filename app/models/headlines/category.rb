module Headlines
  class Category < ActiveRecord::Base
    has_many :domains_categories
    has_many :domains, through: :domains_categories

    has_many :categories

    belongs_to :parent,
      class_name: "Category",
      foreign_key: :category_id

    def parents
      self[:parents].select do |category_id|
        category_id != id
      end
    end
  end
end
