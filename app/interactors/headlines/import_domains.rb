module Headlines
  class ImportDomains
    include Interactor::Organizer

    organize ReadDomains, UpsertDomains
  end
end
