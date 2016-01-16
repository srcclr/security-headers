class AddDataAlexaFlagToHeadlinesDomains < ActiveRecord::Migration
  def change
    add_column :headlines_domains, :refresh_data_alexa, :boolean, default: true
  end
end
