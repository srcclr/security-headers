module Headlines
  module SecurityHeaders
    class ContentSecurityPolicy < SecurityHeader
      def initialize(headers, body, url)
        @name = "content-security-policy"
        @value = headers["content-security-policy"] || ""
        @headers = headers
        @body = body
        @url = url
      end

      def score
        valid? ? tests.sum { |t| t[:score] } : CSP_RULES[:no_csp_header]
      end

      def params
        super.merge(tests: tests)
      end

      private

      def valid?
        directives.any? && directives.all?(&:valid?)
      end

      def directives
        @directives ||= header_directives
        meta_directives.each do |meta_directive|
          directive = @directives.find { |d| d.name == meta_directive.name }
          directive ? directive.merge(meta_directive) : @directives.push(meta_directive)
        end

        @directives
      end

      def header_directives
        @header_directives ||= from_value.select { |d| Headlines::CSP_DIRECTIVES.include?(d.name) }
      end

      def from_value
        value.split(";").map { |d| Headlines::SecurityHeaders::CspDirective.new(d) }
      end

      def meta_directives
        Nokogiri::HTML(@body).xpath(
          "html/head/meta[" \
          "translate(@http-equiv, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" \
          "='content-security-policy']/@content"
        ).map do |attr|
          Headlines::SecurityHeaders::CspDirective.new(attr.value, true)
        end
      end

      def tests
        Headlines::CSP_RULES.keys.map do |test|
          {
            name: test,
            score: send("#{test}?") ? Headlines::CSP_RULES[test] : 0
          }
        end
      end

      Headlines::CSP_RULES.keys.each do |rule|
        define_method("#{rule}?") do
          directives.any? { |d| d.send("#{rule}?") }
        end
      end

      def no_csp_header?
        directives.empty?
      end

      def invalid_csp_header?
        directives.any?(&:invalid?)
      end

      def identical_report_policy?
        directives.any? { |d| d.name == "report-uri" } || value == @headers["content-security-policy-report-only"]
      end

      def no_identical_report_policy?
        valid? && !identical_report_policy?
      end

      def report_only_header_in_meta?
        Nokogiri::HTML(@body).xpath(
          "html/head/meta[" \
          "translate(@http-equiv, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" \
          "='content-security-policy-report-only']"
        ).any?
      end

      def csp_in_meta_and_link_header?
        directives.any?(&:in_meta) && @headers["link"]
      end

      def csp_not_in_top_of_meta?
        directives.any?(&:in_meta) && first_meta_tag_name == "content-security-policy"
      end

      def first_meta_tag_name
        Nokogiri::HTML(@body).xpath("html/head/meta")[0].attributes.keys[0].downcase
      end

      def ok?
        score == 3
      end

      def warn?
        score == 2
      end
    end
  end
end
