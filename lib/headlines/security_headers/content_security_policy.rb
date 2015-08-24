module Headlines
  module SecurityHeaders
    class ContentSecurityPolicy < SecurityHeader
      RULES = %w(restrictive_default_settings
                 allows_unsecured_http
                 allows_unsecured_http2
                 permissive_default_settings
                 scripts_from_any_host
                 styles_from_any_host
                 restrict_javascript
                 restrict_stylesheets
                 javascript_nonce
                 stylesheets_nonce
                 unsafe_eval_without_nonce
                 unsafe_inline_without_nonce
                 identical_report_policy
                 allow_potentially_unsecure_host
                 report_only_header_in_meta
                 frame_ancestors_in_meta
                 sandbox_in_meta
                 csp_in_meta_and_link_header)

      SRC_DIRECTIVES = %w(child-src
                          connect-src
                          default-src
                          font-src
                          frame-src
                          img-src
                          media-src
                          object-src
                          script-src
                          style-src)

      OTHER_DIRECTIVES = %w(base-uri form-action frame-ancestors plugin-types report-uri sandbox)
      ALL_DIRECTIVES = SRC_DIRECTIVES + OTHER_DIRECTIVES

      def initialize(name, url, response)
        @name = name
        @value = response.headers["content-security-policy"]
        @report_only_value = response.headers["content-security-policy-report-only"]
        @response = response
        @url = url
      end

      def score
        valid? ? score_by_value : -15
      end

      private

      def meta_directives
        @meta_directives ||= {}

        Nokogiri::HTML(@response.body).xpath(
          "html/head/meta[" \
          "translate(@http-equiv, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" \
          "='content-security-policy']/@content"
        ).map do |attr|
          @meta_directives[attr.value.split(" ")[0]] = attr.value.split(" ")[1..-1].join(" ")
        end

        @meta_directives
      end

      def valid?
        directives.any? && !invalid_none_directive?
      end

      def invalid_none_directive?
        none_directives.map { |_name, value| value.split(" ").size > 1 }.any?
      end

      def directives
        @directives ||= header_directives
        ALL_DIRECTIVES.each do |directive|
          if meta_directives[directive]
            if @directives[directive]
              @directives[directive] = (@directives[directive].split(" ") & meta_directives[directive].split(" ")).join(" ")
            else
              @directives[directive] = meta_directives[directive]
            end
          end
        end
        @directives
      end

      def from_value
        value.split(";").map { |d| [d.split(" ")[0], d.split(" ")[1..-1].join(" ")] }
      end

      def header_directives
        @header_directives ||= from_value.to_h.slice(*ALL_DIRECTIVES)
      end

      def none_directives
        directives.select { |k, v| SRC_DIRECTIVES.include?(k) && (v.include?("'*'") || v.include?("'none'")) }
      end

      def score_by_value
        RULES.inject(0) { |a, e| a + send(e) }
      end

      def such_directive?(directive, value)
        directives.select { |k, v| k == directive && v =~ value }.any?
      end

      def restrictive_default_settings
        such_directive?("default-src", /^('none'|'self')$/) ? 4 : 0
      end

      def allows_unsecured_http
        directives.select { |_k, v| v.split(" ").include?("http:") }.any? ? -1 : 0
      end

      def allows_unsecured_http2
        directives.select { |name| http_domain_name?(name) && !https_value?(name) }.any? ? -1 : 0
      end

      def http_domain_name?(directive)
        directives[directive].split(" ").select { |v| v.include?(".") && !v.start_with?("https://") }.any?
      end

      def https_value?(directive)
        directives[directive].split(" ").include?("https:")
      end

      def permissive_default_settings
        such_directive?("default-src", /^'\*'$/) ? -2 : 0
      end

      def scripts_from_any_host
        such_directive?("script-src", /^'\*'$/) ? -2 : 0
      end

      def styles_from_any_host
        such_directive?("style-src", /^'\*'$/) ? -2 : 0
      end

      def restrict_javascript
        such_directive?("script-src", /^'self'$/) ? 1 : 0
      end

      def restrict_stylesheets
        such_directive?("style-src", /^'self'$/) ? 1 : 0
      end

      def javascript_nonce
        such_directive?("script-src", /^'nonce-/) ? 2 : 0
      end

      def stylesheets_nonce
        such_directive?("style-src", /^'nonce-/) ? 2 : 0
      end

      def in_list?(name)
        %w(default-src script-src style-src).include?(name)
      end

      def unsafe_eval_without_nonce
        directives.select { |k, v| in_list?(k) && v =~ /'unsafe-eval'/ && !(v =~ /'nonce'/) }.any? ? -2 : 0
      end

      def unsafe_inline_without_nonce
        directives.select { |k, v| in_list?(k) && v =~ /'unsafe-inline'/ && !(v =~ /'nonce'/) }.any? ? -2 : 0
      end

      def identical_report_policy
        directives["report-uri"] || @value == @report_only_value ? 2 : -2
      end

      def allow_potentially_unsecure_host
        hosts = %w(default-src script-src style-src).map do |directive|
          directives[directive].split(" ").map { |v| v.gsub(%r{(https?://)?(www.)?}, "") } if directives[directive]
        end.flatten
        ((hosts - ["'none'", "'self'"]) - SiteSetting.whitelisted_domains.split("|")).any? ? 0 : 0
      end

      def report_only_header_in_meta
        Nokogiri::HTML(@response.body).xpath(
          "html/head/meta[" \
          "translate(@http-equiv, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')" \
          "='content-security-policy-report-only']"
        ).any? ? -1 : 0
      end

      def frame_ancestors_in_meta
        meta_directives["frame-ancestors"] ? -1 : 0
      end

      def sandbox_in_meta
        meta_directives["sandbox"] ? -1 : 0
      end

      def csp_in_meta_and_link_header
        (meta_directives.any? && @response.headers["link"]) ? -2 : 0
      end

      def csp_not_in_top_of_meta
        (meta_directives.any? && first_meta_tag_name == "content-security-policy") ? -2 : 0
      end

      def first_meta_tag_name
        Nokogiri::HTML(@response.body).xpath("html/head/meta")[0].attributes.keys[0].downcase
      end
    end
  end
end
