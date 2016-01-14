class CreateHeadlinesFavouriteDomains < ActiveRecord::Migration
  def change
    create_table :headlines_favourite_domains do |t|
      t.string :url

      t.timestamps
    end
  end
end
