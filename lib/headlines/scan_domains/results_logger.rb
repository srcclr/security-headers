module Headlines
  module ScanDomains
    class ResultsLogger
      attr_reader :logger, :failure_logger
      private :logger, :failure_logger

      def initialize
        @logger = Logger.new(Rails.root.join("log/scan_domains.log"))
        @failure_logger = Logger.new(Rails.root.join("log/scan_domains_failure.log"))
      end

      def log_scan_result(domain, result)
        logger.info("#{domain.label} scan result: #{result.success? ? 'success' : 'failure'}")
        return if result.success?

        failure_logger.info("#{domain.label}: #{error_message(result)}")
      end

      def log_exception(exception)
        failure_logger.info("Unhandled exception: #{exception}")
      end

      def log_failure(result)
        failure_logger.info("#{result.value.url}: Failure reason: #{result.reason}")
      end

      private

      def error_message(result)
        if result.status.present?
          "Status #{result.status}"
        elsif result.errors.present?
          "Error #{result.errors}"
        else
          "Unknown error"
        end
      end
    end
  end
end
