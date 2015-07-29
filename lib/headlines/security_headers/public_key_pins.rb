require "uri"

module Headlines
  module SecurityHeaders
    class PublicKeyPins < SecurityHeader
      def score
        return 0 unless enabled? && max_age
        return 1 if report_only?

        score = 2
        score += 1 if include_subdomains?
        score += 1 if report_uri =~ URI.regexp
        score
      end

      private

      def max_age
        Regexp.last_match[1] if value =~ /max-age=(\d+)/
      end

      def include_subdomains?
        value.gsub(" ", "").scan(";includeSubDomains").any?
      end

      def report_uri
        Regexp.last_match[1] if value =~ /report-uri=(.+)/
      end

      def enabled?
        value =~ /pin-sha256=.{44}/
      end

      def report_only?
        value =~ /report-only$/i
      end
    end
  end
end
