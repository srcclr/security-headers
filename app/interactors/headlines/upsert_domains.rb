module Headlines
  class UpsertDomains
    include Interactor

    ATTRIBUTES = %w(rank data_alexa country_code)

    def call
      connection do |upsert|
        context.domains.each { |domain| add_domain(upsert, domain) }
      end
    end

    private

    def add_domain(upsert, domain)
      upsert.row({name: domain.name }, slice_attributes(domain))
    end

    def slice_attributes(domain, curret_time: Time.zone.now)
      domain.attributes.slice(*ATTRIBUTES).merge(
        created_at: curret_time,
        updated_at: curret_time
      )
    end

    def connection(&block)
      Upsert.batch(Domain.connection, Domain.table_name, &block)
    end
  end
end
