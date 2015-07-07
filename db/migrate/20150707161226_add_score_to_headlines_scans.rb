class AddScoreToHeadlinesScans < ActiveRecord::Migration
  def change
    add_column :headlines_scans, :score, :integer, default: 0
  end
end
