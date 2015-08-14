module Headlines
  class AnalyzeDomainHeaders
    include Interactor::Organizer

    organize ParseSecurityHeaders, GenerateHeadersParamsHash, GenerateScanResultsHash
  end
end
