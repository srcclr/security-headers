class CreateHeadlinesScans < ActiveRecord::Migration
  def change
    create_table :headlines_scans do |t|
      t.json :headers, default: {}, null: false
      t.hstore :results, default: {}, null: false, using: :gin
      t.references :headlines_domain, index: true, foreign_key: true

      t.timestamps
    end
  end
end
