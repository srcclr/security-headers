module Headlines
  module SecurityHeaders
    class SecurityHeader
      attr_reader :name, :value

      EMPTY_SCORE = 0

      def initialize(name, value)
        @name = name
        @value = value
      end

      def params
        @params ||= parse.merge!(value: value)
      end

      def parse
        {}
      end

      def score
        params[:enabled] ? 100 : 0
      end
    end
  end
end
