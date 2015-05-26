module Headlines
  module SecurityHeaders
    class XFrameOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = true
          results[:sameorigin] = @value.scan("sameorigin").any?
        end
      end
    end
  end
end
