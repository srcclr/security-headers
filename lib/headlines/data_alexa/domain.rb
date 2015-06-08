module Headlines
  class DataAlexa
    class Domain
      attr_reader :document

      def initialize(document)
        @document = Nokogiri.XML(document)
      end

      def description
        document.search("DMOZ SITE").first["DESC"]
      end

      def country_name
        country["NAME"] || ""
      end

      def country_code
        country["CODE"] || ""
      end

      def categories
        document.search("DMOZ SITE CATS CAT").map do |node|
          Category.new(node)
        end
      end

      private

      def country
        @country ||= document.search("SD COUNTRY").first || {}
      end
    end
  end
end
