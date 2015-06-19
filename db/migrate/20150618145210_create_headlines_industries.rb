class CreateHeadlinesIndustries < ActiveRecord::Migration
  def change
    create_table :headlines_industries do |t|
      t.string :name, null: false, default: ''
      t.string :categories, array: true, default: [], null: false

      t.timestamps null: false
    end
  end
end
