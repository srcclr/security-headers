module Headlines
  module SecurityHeaders
    class XDownloadOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = value.eql?("noopen")
        end
      end

      def score
        params[:enabled] ? 1 : 0
      end
    end
  end
end
