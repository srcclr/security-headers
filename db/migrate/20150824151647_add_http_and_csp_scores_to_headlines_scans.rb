class AddHttpAndCspScoresToHeadlinesScans < ActiveRecord::Migration
  def change
    add_column :headlines_scans, :http_score, :integer, default: 0
    add_column :headlines_scans, :csp_score, :integer, default: 0
  end
end
