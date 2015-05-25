module Headlines
  class DataAlexa
    URL = "http://data.alexa.com/data?cli=10"

    autoload "Category", "headlines/data_alexa/category"

    attr_reader :domain

    def initialize(domain)
      @domain = domain
    end

    def description
      document.search("DMOZ SITE").first["DESC"]
    end

    def coutry
      @coutry ||= document.search("SD COUNTRY").first
    end

    def country_name
      coutry["NAME"]
    end

    def country_code
      coutry["CODE"]
    end

    def categories
      document.search("DMOZ SITE CATS CAT").map do |node|
        Category.new(node)
      end
    end

    private

    def url
      "#{URL}&url=#{domain}"
    end

    def xml
      Faraday.get(url).body
    end

    def document
      @document ||= Nokogiri.XML(xml)
    end
  end
end
