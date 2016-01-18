module Jobs
  module Headlines
    module ScanFavoriteDomains
      class Daily < Jobs::Headlines::ScanFavoriteDomains::Base
        every 1.day

        def initialize
          @notification_type = "daily"
        end
      end
    end
  end
end
