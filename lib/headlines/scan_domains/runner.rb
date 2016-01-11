require "concurrent"

module Headlines
  module ScanDomains
    class Runner
      DEFAULT_BATCH_SIZE = 50

      attr_reader :total_count, :progressbar, :logger
      private :total_count, :progressbar, :logger

      def initialize(total_count, progressbar)
        @total_count = total_count
        @progressbar = progressbar
        @logger = Headlines::ScanDomains::ResultsLogger.new
      end

      def call
        Headlines::Domain.find_in_batches(batch_size: batch_size) do |domains|
          scan_domains(domains)

          break if progressbar.progress >= total_count
        end
      end

      private

      def batch_size
        @batch_size ||= [default_batch_size, total_count].min
      end

      def default_batch_size
        SiteSetting.scan_proccess_count || DEFAULT_BATCH_SIZE
      end

      def scan_domains(domains)
        results = domains.map do |domain|
          [domain, Headlines::ScanDomains::Scanner.new(domain).async.scan!]
        end

        while results.any?
          results.delete_if do |domain_with_result|
            result = domain_with_result[1]
            if result.complete?
              progressbar.increment

              result.fulfilled? ? save_result(result.value) : logger.log_failure(*domain_with_result)
            end
            !result.pending?
          end

          sleep(1)
        end
      rescue StandardError => exception
        logger.log_exception(exception)
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
