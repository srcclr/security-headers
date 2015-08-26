require_relative "headlines/engine"
require_relative "headlines/top_million_domain"
require "faraday"
require "faraday_middleware"
require "zip"
require "interactor/rails"
require "upsert"
require "responders"
require "active_model_serializers"
require_relative "headlines/domains_archive"
require_relative "headlines/security_headers/security_header"
require_relative "headlines/security_headers/strict_transport_security"
require_relative "headlines/security_headers/x_content_type_options"
require_relative "headlines/security_headers/x_download_options"
require_relative "headlines/security_headers/x_permitted_cross_domain_policies"
require_relative "headlines/security_headers/x_frame_options"
require_relative "headlines/security_headers/x_xss_protection"
require_relative "headlines/security_headers/public_key_pins"
require_relative "headlines/data_alexa"

module Headlines
  SECURITY_HEADERS = %w(strict-transport-security
                        x-xss-protection
                        x-content-type-options
                        x-download-options
                        x-frame-options
                        public-key-pins
                        x-permitted-cross-domain-policies)

  SECURITY_HEADERS_EMPTY_SCORES = {
    "strict-transport-security" => -1,
    "x-xss-protection" => -1,
    "x-content-type-options" => 0,
    "x-download-options" => 0,
    "x-frame-options" => -1,
    "public-key-pins" => 0,
    "x-permitted-cross-domain-policies" => 0,
    "content-security-policy" => -15
  }

  CSP_RULES = { restrictive_default_settings: [4, 0],
                allows_unsecured_http: [-1, 0],
                allows_unsecured_http2: [-1, 0],
                permissive_default_settings: [-2, 0],
                scripts_from_any_host: [-2, 0],
                styles_from_any_host: [-2, 0],
                restrict_javascript: [1, 0],
                restrict_stylesheets: [1, 0],
                javascript_nonce: [2, 0],
                stylesheets_nonce: [2, 0],
                unsafe_eval_without_nonce: [-2, 0],
                unsafe_inline_without_nonce: [-2, 0],
                identical_report_policy: [2, -2],
                allow_potentially_unsecure_host: [0, 0],
                report_only_header_in_meta: [-1, 0],
                frame_ancestors_in_meta: [-1, 0],
                sandbox_in_meta: [-1, 0],
                csp_in_meta_and_link_header: [-2, 0],
                csp_not_in_top_of_meta: [-2, 0] }

  CSP_DIRECTIVES = %w(child-src
                      connect-src
                      default-src
                      font-src
                      frame-src
                      img-src
                      media-src
                      object-src
                      script-src
                      style-src
                      base-uri
                      form-action
                      frame-ancestors
                      plugin-types
                      report-uri
                      sandbox)
end

require_relative "headlines/security_headers/csp_directive"
require_relative "headlines/security_headers/content_security_policy"
require_relative "headlines/vulnerabilities_report"
