module Headlines
  module SecurityHeaders
    class XFrameOptions < SecurityHeader
      def parse
        @params[:sameorigin] = @header.scan("sameorigin").any?
        self
      end
    end
  end
end
