module Headlines
  module ScanDomains
    class ResultsLogger
      attr_reader :logger, :failure_logger, :process_logger
      private :logger, :failure_logger, :process_logger

      def initialize(process_num = nil)
        @logger = Logger.new(Rails.root.join("log/scan_domains.log"))
        @failure_logger = Logger.new(Rails.root.join("log/scan_domains_failure.log"))
        @process_logger = Logger.new(Rails.root.join("log/scan_domains_process_#{process_num.to_i}.log"))
      end

      def log_scan_result(domain, result)
        logger.info("#{domain.label} scan result: #{result.success? ? 'success' : 'failure'}")
        return if result.success?

        failure_logger.info("#{domain.label}: #{error_message(result)}")
      end

      def log_exception(exception)
        failure_logger.info("Unhandled exception: #{exception}")
      end

      def log_failure(domain, result)
        failure_logger.info("#{domain.label}: Failure reason: #{result.reason}")
      end

      def log_process(msg)
        process_logger.info(msg)
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
