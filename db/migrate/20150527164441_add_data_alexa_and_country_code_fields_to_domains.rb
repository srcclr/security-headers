class AddDataAlexaAndCountryCodeFieldsToDomains < ActiveRecord::Migration
  def change
    add_column :headlines_domains, :coutry_code, :string, null: false, default: ''
    add_column :headlines_domains, :data_alexa, :xml
  end
end
