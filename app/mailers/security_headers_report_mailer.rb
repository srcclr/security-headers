require_dependency "email/message_builder"

class SecurityHeadersReportMailer < ActionMailer::Base
  include Email::BuildEmailHelper

  attr_reader :user, :scan_result
  private :user, :scan_result

  def report(user, scan_result)
    @user = user
    @scan_result = scan_result

    build_email(user.email, email_opts)
  end

  private

  def html
    ActionView::Base.new("plugins/security-headers/app/views").render(
      template: 'email/security_headers_report',
      format: :html,
      locals: {
        username: user.username,
        scan_result: scan_result
      }
    )
  end

  def premailed_html
    Premailer.new(html.to_s, with_html_string: true).to_inline_css
  end

  def email_opts
    {
      template: "security_headers_report",
      html_override: premailed_html
    }
  end
end
