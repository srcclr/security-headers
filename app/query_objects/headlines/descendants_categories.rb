module Headlines
  class DescendantsCategories
    COLUMNS = (Headlines::Category.column_names - ["category_id"]).map do |column|
      "categories.#{column} AS #{column}"
    end

    RECURSIVE = <<-SQL
     SELECT #{COLUMNS.join(",")}, categories.id AS category_id
     FROM #{Headlines::Category.table_name} categories
     WHERE categories.category_id = %{root_category_id}

     UNION ALL

     SELECT #{COLUMNS.join(",")}, tree.category_id AS category_id
     FROM #{Headlines::Category.table_name} categories, tree
     WHERE tree.id = categories.category_id
    SQL

    attr_reader :tree_sql
    private :tree_sql

    delegate :first, :includes, :joins, :where, to: :all

    def initialize(root_category_id: 1)
      @tree_sql = RECURSIVE % { root_category_id: root_category_id }
    end

    def all
      Category.with.recursive(tree: tree_sql).from("tree AS #{Headlines::Category.table_name}")
    end
  end
end
