module Jobs
  module Headlines
    class ScanDomain < Jobs::Base
      def execute(args)
        @notification_type = args[:notification_type]
        @domain = ::Headlines::FavoriteDomain.find(args[:domain_id])
        scan_result = ::Headlines::AnalyzeDomainHeaders.call(url: @domain.url)
        users.find_each do |user|
          send_report(user, scan_result)
        end
      end

      private

      def users
        User
          .includes(:favorite_domain_notifications)
          .where(headlines_email_notifications: { notification_type: @notification_type, favorite_domain_id: @domain.id })
      end

      def send_report(user, scan_result)
        report = SecurityHeadersReportMailer.report(user, scan_result)
        Email::Sender.new(report, :security_headers).send
      end
    end
  end
end
