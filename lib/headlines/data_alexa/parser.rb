module Headlines
  class DataAlexa
    class Parser
      attr_reader :document

      def initialize(document)
        @document = Nokogiri.XML(document)
      end

      def request_limit?
        document.search("RLS RL").any?
      end

      def country_code
        country["CODE"] || ""
      end

      private

      def country
        @country ||= document.search("SD COUNTRY").first || {}
      end
    end
  end
end
