class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments, id: :uuid do |t|
      t.integer :appointment_type
      t.integer :status
      t.uuid :customer_id, null: false
      t.boolean :new_customer
      t.text :note
      t.date :scheduled_date
      t.time :scheduled_start
      t.time :scheduled_end
      t.uuid :created_by, null: false
      t.uuid :completed_by
      t.timestamps
    end

    # Add foreign key constraints and indexes
    add_foreign_key :appointments, :users, column: :customer_id, primary_key: :id
    add_index :appointments, :customer_id  # Index for customer_id foreign key

    add_foreign_key :appointments, :users, column: :created_by, primary_key: :id
    add_index :appointments, :created_by  # Index for created_by foreign key

    add_foreign_key :appointments, :users, column: :completed_by, primary_key: :id
    add_index :appointments, :completed_by  # Index for completed_by foreign key
  end
end
