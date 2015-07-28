module Headlines
  module SecurityHeaders
    class XContentTypeOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = value.eql?("nosniff")
        end
      end

      def score
        params[:enabled] ? 1 : 0
      end
    end
  end
end
