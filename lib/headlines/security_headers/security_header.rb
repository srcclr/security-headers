module Headlines
  module SecurityHeaders
    class SecurityHeader
      def initialize(header)
        @name = header[0]
        @value = header[1]
      end

      def params
        @params ||= parse.merge!(name: @name, value: @value)
      end

      def parse
        {}
      end

      def score
        params[:enabled] ? 1 : 0
      end
    end
  end
end
