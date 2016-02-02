namespace :headlines do
  namespace :domains do
    DOMAINS_CATEGORIES = <<-SQL
      SELECT DISTINCT unnest(array_accum(parents)) parents
      FROM headlines_categories
      INNER JOIN headlines_domains_categories
      ON headlines_categories.id = headlines_domains_categories.category_id
      WHERE headlines_domains_categories.domain_name = '%{domain_name}';
    SQL

    def domain_categories(domain_name)
      categories = Headlines::Domain.connection.execute(
        DOMAINS_CATEGORIES % { domain_name: domain_name }
      ).values.flatten

      categories.empty? ? [default_category.id] : categories
    end

    def default_category
      @default_category ||= Headlines::Category.find_or_create_by(
        id: Headlines::Category.order(id: :desc).first.id.to_i + 1,
        title: "Miscellaneous",
        topic: "Top/Miscellaneous",
        category_id: 1
      )
    end

    desc "Refresh list of categories for each domain"
    task refresh_categories: :environment do
      puts "Collect categories for each domain"
      Headlines::Domain.connection.execute(<<-SQL)
        DROP AGGREGATE IF EXISTS array_accum(anyarray);
        CREATE AGGREGATE array_accum(anyarray)
        (sfunc = array_cat, stype = anyarray, initcond = '{}');
      SQL

      progressbar = ProgressBar.create(total: Headlines::Domain.count, format: "%a %e %P% Processed: %c from %C")
      Headlines::Domain.find_each do |domain|
        domain.update_attributes(parent_category_ids: domain_categories(domain.name))
        Rails.logger.info("Domain categories: #{domain.name} completed.")
        progressbar.increment
      end

      Headlines::Domain.connection.execute("DROP AGGREGATE IF EXISTS array_accum(anyarray)")
    end
  end
end
