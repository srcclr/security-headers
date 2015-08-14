class CreateHeadlinesCategories < ActiveRecord::Migration
  def change
    create_table :headlines_categories do |t|
      t.string :title, null: false, default: ''
      t.string :path, null: false, default: ''

      t.timestamps null: false
    end
  end
end
