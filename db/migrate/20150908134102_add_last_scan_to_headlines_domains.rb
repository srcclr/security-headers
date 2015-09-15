class AddLastScanToHeadlinesDomains < ActiveRecord::Migration
  def change
    add_column :headlines_domains, :last_scan_id, :integer
    add_index :headlines_domains, :last_scan_id
  end
end
