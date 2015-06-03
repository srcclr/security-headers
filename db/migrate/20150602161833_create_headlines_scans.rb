class CreateHeadlinesScans < ActiveRecord::Migration
  def change
    create_table :headlines_scans do |t|
      t.json :headers, default: {}, null: false
      t.hstore :results, default: {}, null: false, using: :gin
      t.belongs_to :domain

      t.timestamps
    end

    add_index :headlines_scans, :domain_id
  end
end
