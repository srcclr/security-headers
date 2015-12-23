module Headlines
  class Domain < ActiveRecord::Base
    validates :name, presence: true

    has_many :scans
    belongs_to :last_scan, class_name: "Scan"
    has_many :domains_categories, foreign_key: :domain_name, primary_key: :name
    has_many :categories, through: :domains_categories

    delegate :categories, to: :data_alexa, prefix: true
    delegate :headers, to: :last_scan, prefix: true
    delegate :score, :http_score, :csp_score, :ssl_enabled, to: :last_scan

    def data_alexa=(value)
      self[:data_alexa] = value
      update_country_code
    end

    def data_alexa
      DataAlexa::Domain.new(self[:data_alexa])
    end

    def label
      "#{id}. #{name}"
    end

    private

    def update_country_code
      self[:country_code] = data_alexa.country_code
    end
  end
end
