require_relative './../../../app/interactors/headlines/parse_security_headers'
require_relative './../../../app/interactors/headlines/generate_results'
require_relative './../../../app/interactors/headlines/analyze_domain_headers'

module Headlines
  module ScanDomains
    class Scanner
      include Concurrent::Async

      attr_reader :domain
      private :domain

      def initialize(domain)
        @domain = domain
      end

      def scan!
        AnalyzeDomainHeaders.call(domain: domain)
      end
    end
  end
end
