module Headlines
  module SecurityHeaders
    class XContentTypeOptions < SecurityHeader
      def score
        value == "nosniff" ? 1 : 0
      end
    end
  end
end
