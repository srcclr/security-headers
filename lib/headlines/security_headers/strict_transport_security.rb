module Headlines
  module SecurityHeaders
    class StrictTransportSecurity < SecurityHeader
      def parse
        {
          max_age: max_age,
          includeSubDomains: include_subdomains?,
          enabled: enabled?
        }
      end

      def score
        enabled? ? score_by_subdomain : -1
      end

      private

      def score_by_subdomain
        include_subdomains? ? 2 : 1
      end

      def enabled?
        max_age && max_age.to_i > 0
      end

      def include_subdomains?
        value.gsub(" ", "").scan(";includeSubDomains").any?
      end

      def max_age
        Regexp.last_match[1] if value =~ /max-age=(\d+)/
      end
    end
  end
end
