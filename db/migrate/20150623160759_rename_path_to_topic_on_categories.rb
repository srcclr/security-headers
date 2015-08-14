class RenamePathToTopicOnCategories < ActiveRecord::Migration
  def up
    rename_column :headlines_categories, :path, :topic
  end

  def down
    rename_column :headlines_categories, :topic, :path
  end
end
