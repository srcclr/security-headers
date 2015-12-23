module Headlines
  module ScanDomains
    class Runner
      DEFAULT_BATCH_SIZE = 2_500

      def initialize(total_count, progressbar)
        @total_count = total_count
        @progressbar = progressbar
      end

      def call
        Headlines::Domain.find_in_batches(batch_size: batch_size) do |domains|
          domains.each do |domain|
            begin
              scan_domain(domain)
            rescue StandardError => exception
              failure_logger.info("#{domain.id}. #{domain.name}:")
              failure_logger.info("  Unhandled exception: #{exception}")
            end

            progressbar.increment
          end

          break if progressbar.progress >= total_count
        end
      end

      private

      attr_reader :total_count, :progressbar

      def batch_size
        [DEFAULT_BATCH_SIZE, total_count].min
      end

      def scan_domain(domain)
        result = Headlines::AnalyzeDomainHeaders.call(url: domain.name)
        if result.success?
          domain.build_last_scan(scan_params(result).merge(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
          domain.save!
        end

        log_scan_result(domain.id, result)
      end

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end

      def log_scan_result(index, result)
        scan_result = result.success? ? "success" : "failure"
        logger.info("[#{index} / #{total_count}] Domain #{result.url} scan result: #{scan_result}")
        return if result.success?

        failure_logger.info("#{index}. #{result.url}")
        failure_logger.info("  Status: #{result.status}") if result.status.present?
        failure_logger.info("  Errors: #{result.errors}") if result.errors.present?
      end

      def logger
        @logger ||= Logger.new(Rails.root.join("log/scan_domains.log"))
      end

      def failure_logger
        @failure_logger ||= Logger.new(Rails.root.join("log/scan_domains_failure.log"))
      end
    end
  end
end
