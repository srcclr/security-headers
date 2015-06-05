class RenameCoutryCodeInHeadlinesDomains < ActiveRecord::Migration
  def change
    rename_column :headlines_domains, :coutry_code, :country_code
  end
end
