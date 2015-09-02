module Headlines
  module SecurityHeaders
    class ContentSecurityPolicy < SecurityHeader
      def initialize(headers, body, url)
        @name = "content-security-policy"
        @value = headers["content-security-policy"]
        @headers = headers
        @body = body
        @url = url
      end

      def score
        valid? ? score_by_value : -15
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
          if directive
            directive.in_meta = true
            directive.sources = directive.sources & meta_directive.sources
          else
            @directives.push(meta_directive)
          end
        end
        @directives
      end

      def header_directives
        @header_directives ||= from_value.select { |d| Headlines::CSP_DIRECTIVES.include?(d.name) }
      end

      def from_value
        return [] unless value

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
        Headlines::CSP_RULES.keys.map { |t| { name: t, result: send(t) } }
      end

      def score_by_value
        tests.sum { |test| test[:result] ? Headlines::CSP_RULES[test[:name]] : 0 }
      end

      Headlines::CSP_RULES.keys.each do |rule|
        define_method("#{rule}") do
          directives.any? { |d| d.send("#{rule}?") }
        end
      end

      def identical_report_policy
        return false unless value

        directives.any? { |d| d.name == "report-uri" } || value == @headers["content-security-policy-report-only"]
      end

      def no_identical_report_policy
        !identical_report_policy
      end

      def report_only_header_in_meta
        Nokogiri::HTML(@body).xpath(
          "html/head/meta[" \
          "translate(@http-equiv, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" \
          "='content-security-policy-report-only']"
        ).any?
      end

      def csp_in_meta_and_link_header
        directives.any?(&:in_meta) && @headers["link"]
      end

      def csp_not_in_top_of_meta
        directives.any?(&:in_meta) && first_meta_tag_name == "content-security-policy"
      end

      def first_meta_tag_name
        Nokogiri::HTML(@body).xpath("html/head/meta")[0].attributes.keys[0].downcase
      end
    end
  end
end
