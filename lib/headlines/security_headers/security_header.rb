module Headlines
  module SecurityHeaders
    class SecurityHeader
      def initialize(value)
        @value = value
      end

      def params
        @params ||= parse.merge!(value: @value)
      end

      def parse
        {}
      end
    end
  end
end
