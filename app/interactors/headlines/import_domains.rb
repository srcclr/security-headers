module Headlines
  class ImportDomains
    include Interactor::Organizer

    organize ReadDomains, CollectDomainsDataAlexa, UpsertDomains
  end
end
