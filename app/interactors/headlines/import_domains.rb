module Headlines
  class ImportDomains
    include Interactor::Organizer

    organize CollectDomainsDataAlexa, UpsertDomains

    def call_with_import
      ReadDomains.call(file: context.file, handler: method(:handler))
    end

    alias_method_chain :call, :import

    private

    def handler(domains)
      context.domains = domains
      call_without_import
    end
  end
end
