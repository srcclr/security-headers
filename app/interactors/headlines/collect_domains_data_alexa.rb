module Headlines
  class CollectDomainsDataAlexa
    include Interactor

    def call
      context.domains.find_each do |domain|
        domain.update(data_alexa: data_alexa(domain))
      end
    end

    private

    def data_alexa(domain)
      DataAlexa.new(domain.name).xml
    end
  end
end
