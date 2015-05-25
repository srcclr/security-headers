module Headlines
  module SecurityHeaders
    class SecurityHeader
      attr_reader :name, :params

      def initialize(header)
        @name = header[0]
        @header = header[1]
        @params = { value: @header, enabled: true }
      end

      def score
        @params[:enabled] ? 1 : 0
      end
    end
  end
end
