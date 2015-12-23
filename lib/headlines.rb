require_relative "headlines/engine"
require_relative "headlines/top_million_domain"
require "faraday"
require "faraday_middleware"
require "zip"
require "interactor/rails"
require "upsert"
require "active_model_serializers"
require "nokogiri"
require_relative "headlines/domains_archive"
require_relative "headlines/scan_domains/runner"
require_relative "headlines/security_headers/security_header"
require_relative "headlines/security_headers/strict_transport_security"
require_relative "headlines/security_headers/x_content_type_options"
require_relative "headlines/security_headers/x_download_options"
require_relative "headlines/security_headers/x_permitted_cross_domain_policies"
require_relative "headlines/security_headers/x_frame_options"
require_relative "headlines/security_headers/x_xss_protection"
require_relative "headlines/security_headers/public_key_pins"
require_relative "headlines/security_headers/x_powered_by"
require_relative "headlines/security_headers/server"
require_relative "headlines/security_headers/content_type"
require_relative "headlines/data_alexa"
require_relative "typhoeus/easy_factory"

module Headlines
  SECURITY_HEADERS = %w(strict-transport-security
                        x-xss-protection
                        x-frame-options
                        public-key-pins
                        x-permitted-cross-domain-policies
                        x-content-type-options
                        x-download-options)

  OTHER_HEADERS = %w(x-powered-by
                     server
                     content-type)

  CSP_RULES = { no_csp_header: -15,
                invalid_csp_header: -15,
                restrictive_default_settings: 4,
                allows_unsecured_http: -1,
                permissive_default_settings: -2,
                scripts_from_any_host: -2,
                styles_from_any_host: -2,
                restrict_javascript: 1,
                restrict_stylesheets: 1,
                javascript_nonce: 2,
                stylesheets_nonce: 2,
                unsafe_eval_without_nonce: -2,
                unsafe_inline_without_nonce: -2,
                identical_report_policy: 2,
                no_identical_report_policy: 0,
                allow_potentially_unsecure_host: 0,
                report_only_header_in_meta: -1,
                frame_ancestors_in_meta: -1,
                sandbox_in_meta: -1,
                csp_in_meta_and_link_header: -2,
                csp_not_in_top_of_meta: -2 }

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
