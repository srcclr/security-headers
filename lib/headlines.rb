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
require_relative "headlines/security_headers/content_security_policy"
require_relative "headlines/security_headers/strict_transport_security"
require_relative "headlines/security_headers/x_content_type_options"
require_relative "headlines/security_headers/x_download_options"
require_relative "headlines/security_headers/x_frame_options"
require_relative "headlines/security_headers/x_xss_protection"
require_relative "headlines/data_alexa"

module Headlines
  SECURITY_HEADERS = %w(strict-transport-security
                        x-xss-protection
                        x-content-type-options
                        x-download-options
                        x-frame-options
                        content-security-policy)
end

require_relative "headlines/vulnerabilities_report"
