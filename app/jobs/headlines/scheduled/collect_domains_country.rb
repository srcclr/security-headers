module Jobs
  module Headlines
    class CollectDomainsCountry < Jobs::Scheduled
      every 30.minutes

      def execute(_args)
        domains.find_each do |domain|
          data_alexa = ::Headlines::DataAlexa.new(domain.name).xml

          break if request_limit?(data_alexa)

          domain.update(data_alexa: data_alexa)
        end
      end

      private

      def domains
        ::Headlines::Domain.where(refresh_data_alexa: true).order(:rank).limit(1_000)
      end

      def request_limit?(data_alexa)
        ::Headlines::DataAlexa::Parser.new(data_alexa).request_limit?
      end
    end
  end
end
