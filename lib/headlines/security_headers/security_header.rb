module Headlines
  module SecurityHeaders
    class SecurityHeader
      attr_reader :name, :value

      def initialize(name, value)
        @name = name
        @value = value
      end

      def params
        { name: name, value: value, score: score, rating: rating }
      end

      private

      def rating
        return "OK" if ok?

        warn? ? "WARN" : "ERROR"
      end

      def ok?
        score > 0
      end

      def warn?
        score == 0
      end
    end
  end
end
