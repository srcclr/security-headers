class RemoveIndustries < ActiveRecord::Migration
  def up
    drop_table :headlines_industries
    remove_column :headlines_categories, :industry_id
  end

  def down
    create_table "headlines_industries", force: :cascade do |t|
      t.string   "name",       default: "", null: false
      t.string   "categories", default: [], null: false, array: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    add_column :headlines_categories, :industry_id, :integer
  end
end
