module Headlines
  class ImportDomains
    include Interactor

    DOMAIN = Struct.new(:rank, :name) do
      def key
        { name: name }
      end

      def to_h
        time = Time.zone.now
        { rank: rank, created_at: time, updated_at: time }
      end
    end

    def call
      context.file.fetch_in_batches(
        batch_size: 1000,
        &method(:upsert)
      )
    end

    private

    def upsert(rows)
      connection do |upsert|
        rows.each { |row| add_row(upsert, normalized_row(row)) }
      end
    end

    def add_row(upsert, domain)
      upsert.row(domain.key, domain.to_h)
    end

    def normalized_row(row)
      DOMAIN.new(*row.split(","))
    end

    def connection(&block)
      Upsert.batch(Domain.connection, Domain.table_name, &block)
    end
  end
end
