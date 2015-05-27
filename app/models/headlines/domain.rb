module Headlines
  class Domain < ActiveRecord::Base
    validates :name, presence: true

    def data_alexa=(value)
      self[:data_alexa] = value
      update_country_code
    end

    private

    def update_country_code
      self[:country_code] = data_alexa.country_code
    end

    def data_alexa
      DataAlexa::Domain.new(self[:data_alexa])
    end
  end
end
