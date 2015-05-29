module Headlines
  class UpsertDomainsCategories
    include Interactor

    def call
      connection do |upsert|
        context.domains.each do |domain|
          add_domains_category(upsert, domain: domain)
        end
      end
    end

    private

    def connection
      Upsert.batch(
        DomainsCategory.connection,
        DomainsCategory.table_name,
        &Proc.new
      )
    end

    def add_domains_category(upsert, domain:)
      domain.data_alexa_categories.each do |category|
        upsert.row({ category_id: category.id, domain_id: domain.id }, timestamps)
      end
    end

    def timestamps(curret_time: Time.zone.now)
      { created_at: curret_time, updated_at: curret_time }
    end
  end
end
