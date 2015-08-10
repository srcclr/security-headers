module Headlines
  module SecurityHeaders
    class XXssProtection < SecurityHeader
      def score
        value.start_with?("1") ? score_by_value : -1
      end

      private

      def score_by_value
        value.gsub(" ", "").scan(";mode=block").any? ? 2 : 1
      end
    end
  end
end
