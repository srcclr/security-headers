require "typhoeus"

module Headlines
  module ScanDomains
    class Runner
      DEFAULT_BATCH_SIZE = 200

      def initialize(total_count, progressbar)
        @total_count = total_count
        @progressbar = progressbar
      end

      def call
        Headlines::Domain.find_in_batches(batch_size: batch_size) do |domains|
          scan_domains(domains)

          break if progressbar.progress >= total_count
        end
      end

      private

      attr_reader :total_count, :progressbar

      def batch_size
        [DEFAULT_BATCH_SIZE, total_count].min
      end

      def scan_domains(domains)
        domain_responses = []
        hydra = Typhoeus::Hydra.hydra

        domains.each do |domain|
          request = Typhoeus::Request.new(
            "http://#{domain.name}",
            headers: header_options,
            followlocation: true,
            maxredirs: 10,
            timeout: 30,
            connecttimeout: 10
          )

          request.on_complete { |response| domain_responses << [domain, response] }
          hydra.queue(request)
        end

        hydra.run

        domain_responses.each do |dr|
          domain = dr.first
          response = dr.second
          analyze_and_save(domain, response)
          progressbar.increment
        end
      rescue StandardError => exception
        failure_logger.info("Unhandled exception: #{exception}")
      end

      def header_options
        {
          accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
          accept_encoding: "none",
          accept_language: "en-US,en;q=0.5",
          user_agent: "Mozilla/5.0 AppleWebKit/537.36 Chrome/46.0.2490.71 Safari/537.36 Firefox/41.0"
        }
      end

      def analyze_and_save(domain, response)
        if response.code == 200
          result = Headlines::AnalyzeDomainHeaders.call(url: domain.name, response: response)

          if result.success?
            domain.build_last_scan(scan_params(result).merge!(domain_id: domain.id, ssl_enabled: result.ssl_enabled))
            domain.save!
          else
            failure_logger.info("#{domain.label}: Failed to parse response")
          end
        end

        log_scan_result(domain, response)
      end

      def scan_params(result)
        result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
      end

      def log_scan_result(domain, response)
        logger.info("#{domain.label} scan result: #{response.success? ? 'success' : 'failure'}")
        return if response.code == 200

        if response.timed_out?
          error_message = "Timed out"
        elsif response.code == 0
          error_message = "Zero code: #{response.return_message}"
        else
          error_message = "Status: #{response.code}"
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
