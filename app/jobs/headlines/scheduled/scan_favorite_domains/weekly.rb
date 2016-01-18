module Jobs
  module Headlines
    module ScanFavoriteDomains
      class Weekly < Jobs::Headlines::ScanFavoriteDomains::Base
        every 1.week

        def initialize
          @notification_type = "weekly"
        end
      end
    end
  end
end
