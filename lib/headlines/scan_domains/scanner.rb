require_relative './../../../app/interactors/headlines/parse_security_headers'
require_relative './../../../app/interactors/headlines/generate_results'
require_relative './../../../app/interactors/headlines/analyze_domain_headers'
require_relative './../../../app/models/headlines/domain'

module Headlines
  module ScanDomains
    class Scanner
      include Concurrent::Async

      DEFAULT_CHUNK_SIZE = 100.freeze

      attr_reader :domain, :logger
      private :domain, :logger

      def initialize(offset, total, progress_hash)
        super()
        @offset = offset
        @total = total
        @progress_hash = progress_hash
        @processed = 0
        @logger = Headlines::ScanDomains::ResultsLogger.new
      end

      def scan!
        begin
          Headlines::Domain.offset(@offset).limit(DEFAULT_CHUNK_SIZE).each do |domain|
            result = AnalyzeDomainHeaders.call(domain: domain)
            save_result(result)
            @progress_hash[:progress] += 1
          end

          @processed += DEFAULT_CHUNK_SIZE
        end while @processed < @total
      end

      def save_result(result)
        domain = result.domain

        if result.success?
          domain.build_last_scan(scan_params(result).merge!(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
          domain.save!
        end

        logger.log_scan_result(domain, result)
      end

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end
    end
  end
end
