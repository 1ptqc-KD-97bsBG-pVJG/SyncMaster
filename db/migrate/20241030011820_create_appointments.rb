class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.integer :type
      t.integer :status
      t.uuid :customer_id
      t.boolean :new_customer
      t.text :note
      t.date :scheduled_date
      t.time :scheduled_start
      t.time :scheduled_end
      t.uuid :created_by
      t.uuid :completed_by

      t.timestamps
    end
  end
end
