class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments, id: :uuid do |t|
      t.integer :appointment_type
      t.integer :status
      t.references :customer, foreign_key: { to_table: :users }, type: :uuid
      t.boolean :new_customer
      t.text :note
      t.date :scheduled_date
      t.time :scheduled_start
      t.time :scheduled_end
      t.references :created_by, foreign_key: { to_table: :users }, type: :uuid
      t.references :completed_by, foreign_key: { to_table: :users }, type: :uuid
      t.timestamps
    end
  end
end
