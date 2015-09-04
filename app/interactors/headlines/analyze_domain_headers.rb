module Headlines
  class AnalyzeDomainHeaders
    include Interactor::Organizer

    organize ParseSecurityHeaders, GenerateResults
  end
end
