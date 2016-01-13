require_relative './../../../app/interactors/headlines/parse_security_headers'
require_relative './../../../app/interactors/headlines/generate_results'
require_relative './../../../app/interactors/headlines/analyze_domain_headers'
require_relative './../../../app/models/headlines/domain'
require_relative './../../../app/models/headlines/scan'

module Headlines
  module ScanDomains
    class Scanner
      include Concurrent::Async

      DEFAULT_CHUNK_SIZE = 100.freeze

      def initialize(offset, total, progress_hash, process_num)
        super()
        @offset = offset
        @total = total
        @progress_hash = progress_hash
        @processed = 0
        @logger = Headlines::ScanDomains::ResultsLogger.new(process_num)
      end

      def scan!
        @logger.log_process("From: #{@offset}\tTo: #{@offset + @total}")

        while @processed < @total
          Headlines::Domain.order(:id).offset(@offset + @processed).limit(chunk_size).each do |domain|
            @logger.log_process(domain.id)
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
          domain.build_last_scan(scan_params(result).merge!(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
          begin
            domain.save!
          rescue StandardError => e
            @logger.log_exception("Scan save failed: #{e}")
          end
        end

        @logger.log_scan_result(domain, result)
      end

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end
    end
  end
end
