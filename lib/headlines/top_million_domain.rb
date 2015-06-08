module Headlines
  class TopMillionDomain
    attr_reader :file

    def initialize(file:)
      @file = file
    end

    def fetch_in_batches(batch_size: 1000, limit: 0)
      yield(stream.take(lines_to_read(batch_size, limit)).to_a) until stop_reading?(limit)
    end

    private

    def lines_to_read(batch_size, limit)
      return batch_size if limit.zero?

      (limit + file.lineno) > batch_size ? batch_size : limit
    end

    def stop_reading?(limit)
      file.eof? || (!limit.zero? && file.lineno >= limit)
    end

    def stream
      @stream ||= file.each_line.lazy
    end
  end
end
