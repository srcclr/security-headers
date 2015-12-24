module Headlines
  class UpsertDomains
    include Interactor

    def call
      connection do |upsert|
        context.domains.each { |domain| add_domain(upsert, domain) }
      end
    end

    private

    def add_domain(upsert, domain)
      upsert.row({ name: domain.name }, slice_attributes(domain))
      context.progressbar.increment
    end

    def slice_attributes(domain, curret_time: Time.zone.now)
      domain.attributes.slice(:rank).merge(
        refresh_data_alexa: true,
        created_at: curret_time,
        updated_at: curret_time
      )
    end

    def connection(&block)
      Upsert.batch(Domain.connection, Domain.table_name, &block)
    end
  end
end
