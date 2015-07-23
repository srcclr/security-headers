namespace :headlines do
  namespace :domains do
    DOMAINS_CATEGORIES = <<-SQL
      SELECT DISTINCT unnest(array_accum(parents)) parents
        FROM headlines_categories,
        LATERAL (
          SELECT domain_name, category_id AS id
            FROM headlines_domains_categories
            WHERE domain_name = '%{domain_name}'
        ) categories
        WHERE headlines_categories.parents && ARRAY[categories.id]
        GROUP BY categories.domain_name;
    SQL

    def domain_categories(domain_name)
      Headlines::Domain.connection.execute(
        DOMAINS_CATEGORIES % { domain_name: domain_name }
      ).values.flatten
    end

    desc "Refresh list of categories for each domain"
    task refresh_categories: :environment do
      Headlines::Domain.connection.execute(<<-SQL)
        DROP AGGREGATE IF EXISTS array_accum(anyarray);
        CREATE AGGREGATE array_accum(anyarray)
        (sfunc = array_cat, stype = anyarray, initcond = '{}');
      SQL

      Headlines::Domain.find_each do |domain|
        domain.update_attributes(parent_category_ids: domain_categories(domain.name))
        Rails.logger.info("Domain categories: #{domain.name} completed.")
      end

      Headlines::Domain.connection.execute("DROP AGGREGATE IF EXISTS array_accum(anyarray)")
    end
  end
end
