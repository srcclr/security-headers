require "typhoeus"
require "concurrent"

module Headlines
  module ScanDomains
    class Runner
      DEFAULT_BATCH_SIZE = 50

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
        @batch_size ||= [DEFAULT_BATCH_SIZE, total_count].min
      end

      def scan_domains(domains)
        results = []

        domains.each do |domain|
          scanner = Headlines::ScanDomains::Scanner.new(domain)
          results << scanner.async.scan!
        end

        while results.any?
          results.delete_if do |r|
            if r.rejected?
              failure_logger.info("#{r.value.try(:effective_url)}: Failure reason: #{r.reason}")
            end

            !r.pending?
          end

          sleep(1)
        end

        progressbar.progress += domains.size
      rescue StandardError => exception
        failure_logger.info("Unhandled exception: #{exception}")
      end

      def failure_logger
        @failure_logger ||= Logger.new(Rails.root.join("log/scan_domains_failure.log"))
      end
    end
  end
end
