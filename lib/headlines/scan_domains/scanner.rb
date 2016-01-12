require_relative './../../../app/interactors/headlines/parse_security_headers'
require_relative './../../../app/interactors/headlines/generate_results'
require_relative './../../../app/interactors/headlines/analyze_domain_headers'
require_relative './../../../app/models/headlines/domain'

module Headlines
  module ScanDomains
    class Scanner
      include Concurrent::Async

      DEFAULT_CHUNK_SIZE = 100.freeze

      def initialize(offset, total, progress_hash)
        super()
        @offset = offset
        @total = total
        @progress_hash = progress_hash
        @processed = 0
        @logger = Headlines::ScanDomains::ResultsLogger.new
      end

      def scan!
        while @processed < @total
          Headlines::Domain.order(:id).offset(@offset).limit(chunk_size).each do |domain|
            result = AnalyzeDomainHeaders.call(domain: domain)
            save_result(domain, result)

            @progress_hash[:progress] += 1
            @processed += 1
          end
        end
      end

      private

      def chunk_size
        [DEFAULT_CHUNK_SIZE, @total - @processed].min
      end

      def save_result(domain, result)
        if result.success?
          new_scan = domain.create_last_scan!(scan_params(result).merge!(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
          domain.update!(last_scan_id: new_scan.id)
        end

        @logger.log_scan_result(domain, result)
      end

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end
    end
  end
end
