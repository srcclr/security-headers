module Jobs
  module Headlines
    class Weekly < Jobs::Headlines::Base
      every 1.week

      def initialize
        @notification_type = "weekly"
      end
    end
  end
end
