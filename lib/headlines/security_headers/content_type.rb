module Headlines
  module SecurityHeaders
    class ContentType < SecurityHeader
      def score
        value.start_with?("text/html") ? score_by_value : 0
      end

      private

      def score_by_value
        utf_charset? ? 2 : 1
      end

      def utf_charset?
        value.gsub(" ", "").downcase.scan("charset=utf-8").any?
      end

      private

      def rating
        ok? ? "OK" : "WARN"
      end

      def ok?
        score == 2
      end
    end
  end
end
