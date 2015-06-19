module Headlines
  class Domain < ActiveRecord::Base
    validates :name, presence: true

    has_many :scans
    has_many :domains_categories
    has_many :categories, through: :domains_categories
    has_many :industries, through: :categories

    delegate :categories, to: :data_alexa, prefix: true

    def data_alexa=(value)
      self[:data_alexa] = value
      update_country_code
    end

    def data_alexa
      DataAlexa::Domain.new(self[:data_alexa])
    end

    private

    def update_country_code
      self[:country_code] = data_alexa.country_code
    end
  end
end
