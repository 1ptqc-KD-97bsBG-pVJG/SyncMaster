class AddUuidToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uuid, :uuid, default: "gen_random_uuid()", null: false

    # Add an index for the UUID column (optional but recommended for performance)
    add_index :users, :uuid, unique: true
  end
end
