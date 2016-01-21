module Jobs
  module Headlines
    class Monthly < Jobs::Headlines::Base
      every 1.month

      def initialize
        @notification_type = "monthly"
      end
    end
  end
end
