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

      private

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
