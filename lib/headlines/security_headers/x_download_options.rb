module Headlines
  module SecurityHeaders
    class XDownloadOptions < SecurityHeader
      def score
        value == "noopen" ? 1 : 0
      end
    end
  end
end
