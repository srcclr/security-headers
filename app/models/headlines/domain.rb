module Headlines
  class Domain < ActiveRecord::Base
    validates :name, presence: true

    has_many :scans
    has_one :scan, -> { order(id: :desc) }
    has_many :domains_categories, foreign_key: :domain_name, primary_key: :name
    has_many :categories, through: :domains_categories

    delegate :categories, to: :data_alexa, prefix: true
    delegate :headers, to: :scan, prefix: true
    delegate :score, :http_score, :csp_score, to: :scan

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
