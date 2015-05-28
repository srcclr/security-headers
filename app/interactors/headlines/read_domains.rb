module Headlines
  class ReadDomains
    include Interactor

    ATTRIBUTES = %i(rank name)

    before do
      context.domains ||= []
    end

    def call
      context.file.fetch_in_batches(
        batch_size: 1000,
        &method(:read_domains)
      )
    end

    private

    def read_domains(rows)
      context.domains.concat(rows.map { |row| row_to_domain(row) })
    end

    def row_to_domain(row)
      Domain.new(row_to_attributes(row))
    end

    def row_to_attributes(row)
      Hash[ATTRIBUTES.zip(row.split(","))]
    end
  end
end
