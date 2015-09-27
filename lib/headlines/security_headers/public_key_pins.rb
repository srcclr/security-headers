require "uri"

module Headlines
  module SecurityHeaders
    class PublicKeyPins < SecurityHeader
      attr_reader :total_score_report
      private :total_score_report

      def initialize(*args)
        @total_score_report = 1
        super
      end

      def score
        enabled? ? send("total_score_#{header_type}") : 0
      end

      private

      def total_score_default
        1 + include_subdomains_score + report_uri_score
      end

      def header_type
        value =~ /report-only$/i ? "report" : "default"
      end

      def include_subdomains_score
        value.gsub(" ", "").scan(";includeSubDomains").any? ? 1 : 0
      end

      def report_uri
        Regexp.last_match[1] if value =~ /report-uri=(.+)/
      end

      def report_uri_score
        report_uri =~ URI.regexp ? 1 : 0
      end

      def enabled?
        (value =~ /max-age=(\d+)/) && (value =~ /pin-sha256=.{44}/)
      end
    end
  end
end
