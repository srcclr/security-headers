module Jobs
  module Headlines
    class Daily < Jobs::Headlines::Base
      every 1.day

      def initialize
        @notification_type = "daily"
      end
    end
  end
end
