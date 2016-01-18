require_dependency "email/message_builder"

class SecurityHeadersReportMailer < ActionMailer::Base
  include Email::BuildEmailHelper

  def report(user, scan_result)
    email_opts = {
      template: "security_headers_report",
      html_override: html(user, scan_result)
    }

    build_email(user.email, email_opts)
  end

  private

  def html(user, scan_result)
    ActionView::Base.new("plugins/security-headers/app/views").render(
      template: 'email/security_headers_report',
      format: :html,
      locals: {
        username: user.username,
        domain_url: scan_result.url
      }
    )
  end
end
