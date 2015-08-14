class CreateHeadlinesDomains < ActiveRecord::Migration
  def change
    create_table :headlines_domains do |t|
      t.string :name, null: false, default: ''
      t.integer :rank, null: false, default: 0

      t.timestamps null: false
    end

    add_index :headlines_domains, :name, unique: true
  end
end
