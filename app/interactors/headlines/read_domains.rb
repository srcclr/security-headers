module Headlines
  class ReadDomains
    include Interactor

    ATTRIBUTES = %i(rank name)

    def call
      context.domains = context.rows.map { |row| row_to_domain(row) }
    end

    private

    def row_to_domain(row)
      Domain.new(row_to_attributes(row))
    end

    def row_to_attributes(row)
      Hash[ATTRIBUTES.zip(row.split(",").map(&:chomp))]
    end
  end
end
