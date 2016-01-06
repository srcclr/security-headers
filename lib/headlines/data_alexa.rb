require_relative "data_alexa/parser"

module Headlines
  class DataAlexa
    URL = "http://data.alexa.com/data?cli=10"

    attr_reader :domain

    def initialize(domain)
      @domain = domain
    end

    def xml
      response.body
    end

    private

    def response
      @response ||= Faraday.get(url)
    end

    def url
      "#{URL}&url=#{domain}"
    end
  end
end
