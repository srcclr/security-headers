module Headlines
  module SecurityHeaders
    class XContentTypeOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = true
          results[:nosniff] = @value.scan("nosniff").any?
        end
      end

      def score
        params[:enabled] && params[:nosniff] ? 1 : 0
      end
    end
  end
end
