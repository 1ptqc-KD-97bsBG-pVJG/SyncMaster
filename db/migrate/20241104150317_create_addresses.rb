class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :street, null: false
      t.string :secondary
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.string :country, null: false
      t.integer :address_type, null: false
      t.timestamps
    end
  end
end
