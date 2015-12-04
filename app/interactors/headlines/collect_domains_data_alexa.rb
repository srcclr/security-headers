module Headlines
  class CollectDomainsDataAlexa
    include Interactor

    def call
      context.domains.each do |domain|
        domain.data_alexa = data_alexa(domain)
        context.progressbar.increment
      end
    end

    private

    def data_alexa(domain)
      DataAlexa.new(domain.name).xml
    end
  end
end
