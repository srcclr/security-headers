module Jobs
  module Headlines
    class CollectDomainsCountry < Jobs::Scheduled
      every 1.day

      def execute(_args)
        ::Headlines::CollectDomainsDataAlexa.call(domains: domains)
      end

      private

      def domains
        ::Headlines::Domain.where(refresh_data_alexa: true).order(:rank).limit(10_000)
      end
    end
  end
end
