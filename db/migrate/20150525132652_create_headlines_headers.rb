class CreateHeadlinesHeaders < ActiveRecord::Migration
  def change
    create_table :headlines_headers do |t|
      t.string :name
      t.hstore :parameters

      t.timestamps
    end
  end
end
