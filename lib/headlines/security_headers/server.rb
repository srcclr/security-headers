module Headlines
  module SecurityHeaders
    class Server < SecurityHeader
      def score
        value.presence ? 1 : 0
      end

      private

      def rating
        ok? ? "OK" : "WARN"
      end

      def ok?
        score == 0
      end
    end
  end
end
