require_relative "data_alexa/category"
require_relative "data_alexa/domain"

module Headlines
  class DataAlexa
    URL = "http://data.alexa.com/data?cli=10"

    attr_reader :domain

    def initialize(domain)
      @domain = domain
    end

    def xml
      Faraday.get(url).body
    end

    private

    def url
      "#{URL}&url=#{domain}"
    end
  end
end
