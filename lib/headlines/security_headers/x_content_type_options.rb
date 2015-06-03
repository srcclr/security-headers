module Headlines
  module SecurityHeaders
    class XContentTypeOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = value.eql?("nosniff")
        end
      end
    end
  end
end
