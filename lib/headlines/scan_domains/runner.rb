require "concurrent"

module Headlines
  module ScanDomains
    class Runner
      DEFAULT_PROCESS_COUNT = 8.freeze

      attr_reader :total_count, :progressbar, :logger
      private :total_count, :progressbar, :logger

      def initialize(total_count, progressbar)
        @total_count = total_count
        @progressbar = progressbar
        @logger = Headlines::ScanDomains::ResultsLogger.new
      end

      def call
        progress_hash = Concurrent::Map.new
        progress_hash[:progress] = 0

        results = process_count.times.map do |n|
          current_batch_size = (n == process_count - 1 ? total_count - batch_size * n : batch_size)
          Headlines::ScanDomains::Scanner.new(batch_size * n, current_batch_size, progress_hash).async.scan!
        end

        while results.any?
          results.delete_if do |result|
            logger.log_exception(result.reason) unless result.fulfilled? || result.pending?

            !result.pending?
          end
          progressbar.progress = progress_hash[:progress]
          sleep(5)
        end
      rescue StandardError => exception
        logger.log_exception(exception)
      end

      private

      def batch_size
        @batch_size ||= total_count.fdiv(process_count).ceil
      end

      def process_count
        @process_count ||= SiteSetting.scan_proccess_count || DEFAULT_PROCESS_COUNT
      end
    end
  end
end
