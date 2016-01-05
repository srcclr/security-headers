module Headlines
  module ScanDomains
    class Scanner
      include Concurrent::Async

      def initialize(domain)
        @domain = domain
      end

      def scan!
        result = AnalyzeDomainHeaders.call(url: domain.name)

        if result.success?
          domain.build_last_scan(scan_params(result).merge!(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
          domain.save!
        end

        log_scan_result(domain, result)
      end

      private

      attr_reader :domain

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end

      def log_scan_result(domain, result)
        logger.info("#{domain.label} scan result: #{result.success? ? 'success' : 'failure'}")
        return if result.success?

        if result.status.present?
          error_message = "Status #{result.status}"
        elsif result.errors.present?
          error_message = "Error #{result.errors}"
        else
          error_message = "Unknown error"
        end

        failure_logger.info("#{domain.label}: #{error_message}")
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
