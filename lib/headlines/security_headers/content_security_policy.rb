module Headlines
  module SecurityHeaders
    class ContentSecurityPolicy < SecurityHeader
      RULES = %w(restrictive_default_settings
                 allows_unsecured_http
                 permissive_default_settings
                 scripts_from_any_host
                 styles_from_any_host
                 restrict_javascript
                 restrict_stylesheets
                 javascript_nonce
                 stylesheets_nonce
                 unsafe_eval_without_nonce
                 unsafe_inline_without_nonce)

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

      def score
        valid? ? score_by_value : -15
      end

      private

      def valid?
        value.presence && invalid_directives? && !invalid_none_directive?
      end

      def invalid_directives?
        (directives.keys - ALL_DIRECTIVES).empty?
      end

      def invalid_none_directive?
        none_directives.map { |_name, value| value.split(" ").size > 1 }.any?
      end

      def directives
        directives = {}
        value.split(";").each { |d| directives[d.split(" ")[0]] = d.split(" ")[1..-1].join(" ") }
        directives
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
        directives.select { |_k, v| v.include?("http:") }.any? ? -1 : 0
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
    end
  end
end
