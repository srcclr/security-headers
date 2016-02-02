class RenameUncategorized < ActiveRecord::Migration
  class Headlines::Category < ActiveRecord::Base; end

  def up
    category = Headlines::Category.find_by(title: "Uncategorized", category_id: 1)
    category.update(
      title: "Miscellaneous",
      topic: "Top/Miscellaneous",
      category_id: 1
    ) if category
  end

  def down
    category = Headlines::Category.find_by(title: "Miscellaneous", category_id: 1)
    category.update(
      title: "Uncategorized",
      topic: "Top/Uncategorized",
      category_id: 1
    ) if category
  end
end
