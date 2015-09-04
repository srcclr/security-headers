module Headlines
  module SecurityHeaders
    class CspDirective
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

      attr_accessor :in_meta
      attr_writer :sources

      def initialize(directive, in_meta = false)
        @directive = directive
        @in_meta = in_meta
      end

      def name
        @name ||= @directive.split(" ")[0]
      end

      def value
        @value ||= sources.join(" ")
      end

      def sources
        @sources ||= @directive.split(" ")[1..-1]
      end

      def sources_hosts
        sources.map { |source| source.gsub(%r{(https?://)?(www.)?}, "") } - ["'none'", "'self'", "'*'"]
      end

      def invalid?
        SRC_DIRECTIVES.include?(name) && (sources.include?("'*'") || sources.include?("'none'")) && sources.size > 1
      end

      def valid?
        !invalid?
      end

      def allows_unsecured_http?
        sources.include?("http:") || (http_domain_name? && !sources.include?("https:"))
      end

      def restrictive_default_settings?
        name == "default-src" && value =~ /\A('none'|'self')\z/
      end

      def permissive_default_settings?
        name == "default-src" && value =~ /\A'\*'\z/
      end

      def scripts_from_any_host?
        name == "script-src" && value =~ /\A'\*'\z/
      end

      def styles_from_any_host?
        name == "style-src" && value =~ /\A'\*'\z/
      end

      def restrict_javascript?
        name == "script-src" && value =~ /\A'self'\z/
      end

      def restrict_stylesheets?
        name == "style-src" && value =~ /\A'self'\z/
      end

      def javascript_nonce?
        name == "script-src" && value =~ /\A'nonce-/
      end

      def stylesheets_nonce?
        name == "style-src" && value =~ /\A'nonce-/
      end

      def unsafe_eval_without_nonce?
        in_list?(name) && sources.include?("'unsafe-eval'") && !(sources.include?("'nonce'"))
      end

      def unsafe_inline_without_nonce?
        in_list?(name) && sources.include?("'unsafe-inline'") && !(sources.include?("'nonce'"))
      end

      def allow_potentially_unsecure_host?
        in_list?(name) && (sources_hosts - SiteSetting.whitelisted_domains.split("|")).any?
      end

      def frame_ancestors_in_meta?
        name == "frame-ancestors" && in_meta
      end

      def sandbox_in_meta?
        name == "sandbox" && in_meta
      end

      private

      def in_list?(name)
        %w(default-src script-src style-src).include?(name)
      end

      def http_domain_name?
        sources.select { |s| s.include?(".") && !s.start_with?("https://") }.any?
      end
    end
  end
end
