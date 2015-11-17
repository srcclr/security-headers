module Headlines
  module SecurityHeaders
    class XFrameOptions < SecurityHeader
      SCORES = { deny: 3,  sameorigin: 2 }
      ALLOW_FROM_REGEXP = %r{\Aallow-from https?://(?<domain>.+)\z}

      def score
        value.presence ? score_by_value : -1
      end

      private

      def score_by_value
        SCORES[value.downcase.to_sym] || score_by_allow_from
      end

      def score_by_allow_from
        whitelisted_domain? ? 1 : -1
      end

      def allow_from_domain
        (ALLOW_FROM_REGEXP.match(value.downcase) || {})[:domain]
      end

      def whitelisted_domain?
        SiteSetting.whitelisted_domains.split("|").include?(allow_from_domain)
      end
    end
  end
end
