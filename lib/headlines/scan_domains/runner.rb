module Headlines
  module ScanDomains
    class Runner
      def initialize(domains)
        @domains = domains
      end

      def call
        @domains.each do |domain|
          scan_domain(domain)
          print "."
        end
      end

      private

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
        logger.info("[#{index} / #{@domains.last.id}] Domain #{result.url} scan result: #{scan_result}")
        return if result.success?

        failure_logger.info("#{index}. #{result.url}")
        failure_logger.info("  Status: #{result.status}") if result.status.present?
        failure_logger.info("  Errors: #{result.errors}") if result.errors.present?
      end

      def logger
        @logger ||= Logger.new(Rails.root.join("log/scan_domains_#{@domains.first.id}_#{@domains.last.id}.log"))
      end

      def failure_logger
        @failure_logger ||= Logger.new(Rails.root.join("log/scan_domains_failure.log"))
      end
    end
  end
end
