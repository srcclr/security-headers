module Jobs
  module Headlines
    class Base < Jobs::Scheduled
      def execute(_args)
        domains.find_each do |domain|
          Jobs.enqueue(
            "Headlines::ScanDomain",
            domain_id: domain.id,
            notification_type: @notification_type
          )
        end
      end

      private

      def domains
        ::Headlines::FavoriteDomain
          .includes(:email_notifications)
          .where(headlines_email_notifications: { notification_type: @notification_type })
      end
    end
  end
end
