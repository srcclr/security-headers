class AddScoreToHeadlinesScans < ActiveRecord::Migration
  def change
    add_column :headlines_scans, :score, :integer, default: 0
    add_index :headlines_scans, :score
  end
end
