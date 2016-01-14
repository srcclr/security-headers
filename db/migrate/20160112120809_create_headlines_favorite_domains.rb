class CreateHeadlinesFavoriteDomains < ActiveRecord::Migration
  def change
    create_table :headlines_favorite_domains do |t|
      t.string :url

      t.timestamps
    end
  end
end
