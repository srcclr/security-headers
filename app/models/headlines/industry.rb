module Headlines
  class Industry < ActiveRecord::Base
    has_many :categories
    has_many :industry_ranked_domains
  end
end
