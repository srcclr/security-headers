module Headlines
  class TopMillionDomain

    attr_reader :file

    def initialize(file:)
      @file = file
    end

    def fetch_in_batches(batch_size: 100, &block)
      yield(stream.take(batch_size).to_a) until file.eof?
    end

    private

    def stream
      @stream ||= file.each_line.lazy
    end
  end
end
