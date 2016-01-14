class CreateHeadlinesEmailNotifications < ActiveRecord::Migration
  def change
    create_table :headlines_email_notifications do |t|
      t.references :user, index: true
      t.references :favorite_domain, index: true
      t.string :notification_type, default: "never", null: false

      t.timestamps
    end
  end
end
