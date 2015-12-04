namespace :headlines do
  namespace :categories do
    desc "Refresh list of parents for each category"
    task refresh_parents: :environment do
      puts "Collect parent categories for each category"

      Headlines::Category.connection.execute(<<-SQL)
        WITH RECURSIVE nodes (id, parents) AS (
          SELECT id, ARRAY[id]
          FROM #{Headlines::Category.table_name} categories
          WHERE category_id = 1

          UNION ALL

          SELECT categories.id, nodes.parents || categories.id
          FROM #{Headlines::Category.table_name} categories, nodes
          WHERE category_id = nodes.id
        )

        UPDATE #{Headlines::Category.table_name} categories SET parents = nodes.parents
        FROM nodes
        WHERE nodes.id = categories.id
      SQL
    end
  end
end
