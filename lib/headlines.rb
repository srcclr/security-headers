require "headlines/engine"
require "headlines/top_million_domain"
require "faraday"
require "faraday_middleware"
require "zip"
require "interactor/rails"
require "upsert"
require "responders"
require "active_model_serializers"
require "schema_plus"
require "headlines/domains_archive"
require "headlines/security_headers/security_header"
require "headlines/security_headers/content_security_policy"
require "headlines/security_headers/strict_transport_security"
require "headlines/security_headers/x_content_type_options"
require "headlines/security_headers/x_frame_options"
require "headlines/security_headers/x_xss_protection"
require "headlines/data_alexa"

module Headlines
  SECURITY_HEADERS = %w(strict-transport-security
                        x-xss-protection
                        x-content-type-options
                        x-frame-options
                        content-security-policy)
end
