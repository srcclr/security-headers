module Jobs
  module Headlines
    module ScanFavoriteDomains
      class Monthly < Jobs::Headlines::ScanFavoriteDomains::Base
        every 1.month

        def initialize
          @notification_type = "monthly"
        end
      end
    end
  end
end
