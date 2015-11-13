class AddSslEnabledToHeadlinesScans < ActiveRecord::Migration
  def change
    add_column :headlines_scans, :ssl_enabled, :boolean
  end
end
