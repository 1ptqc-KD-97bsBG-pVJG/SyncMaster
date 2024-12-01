class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :sent_to_id, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.integer :notification_type
      t.text :message
      t.datetime :sent_at
      t.integer :status

      t.timestamps
    end
  end
end