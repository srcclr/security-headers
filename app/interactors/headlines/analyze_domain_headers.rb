module Headlines
  class AnalyzeDomainHeaders
    include Interactor::Organizer

    before :set_url

    organize ParseSecurityHeaders, GenerateResults

    private

    def set_url
      context.url ||= context.domain.name
    end
  end
end
