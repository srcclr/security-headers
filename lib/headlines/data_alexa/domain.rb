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

      def coutry
        @coutry ||= document.search("SD COUNTRY").first || {}
      end
    end
  end
end
