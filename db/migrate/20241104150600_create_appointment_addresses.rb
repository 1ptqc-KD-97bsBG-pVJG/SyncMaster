class CreateAppointmentAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_addresses, id: :uuid do |t|
      t.references :appointment, null: false, foreign_key: true, type: :uuid
      t.references :address, null: false, foreign_key: true, type: :uuid
      t.text :note

      t.timestamps
    end
  end
end
