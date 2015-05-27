class AddDescriptionAndCountryCodeColumnsToDomains < ActiveRecord::Migration
  def change
    add_column :headlines_domains, :description, :text, null: false, default: ''
    add_column :headlines_domains, :country_code, :string, null: false, default: ''
  end
end
