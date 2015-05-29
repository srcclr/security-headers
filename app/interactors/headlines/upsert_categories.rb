module Headlines
  class UpsertCategories
    include Interactor

    def call
      connection do |upsert|
        context.domains.each { |domain| add_categories(upsert, domain: domain) }
      end
    end

    private

    def connection
      Upsert.batch(Category.connection, Category.table_name, &Proc.new)
    end

    def add_categories(upsert, domain:)
      domain.data_alexa_categories.each do |category|
        upsert.row({ id: category.id }, category.to_h.merge(timestamps))
      end
    end

    def timestamps(curret_time: Time.zone.now)
      { created_at: curret_time, updated_at: curret_time }
    end
  end
end
