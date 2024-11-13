class ChangeCustomerIdToCustomerNameInAppointments < ActiveRecord::Migration[7.1]
  def change
    # Remove the customer_id field (including its index if it exists)
    remove_index :appointments, :customer_id
    remove_column :appointments, :customer_id, :uuid
    # Add the customer_name field as a string type
    add_column :appointments, :customer_name, :string
  end
end
