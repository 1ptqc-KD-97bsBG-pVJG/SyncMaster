class SwitchUsersToUuid < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Rename the old id column
    rename_column :users, :id, :integer_id

    # Step 2: Rename the new uuid column to id
    rename_column :users, :uuid, :id

    # Step 3: Set the new id column (uuid) as the primary key
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey;"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    # Step 4: Remove the default value for integer_id
    execute "ALTER TABLE ONLY users ALTER COLUMN integer_id DROP DEFAULT;"

    # Step 5: Drop the auto-increment sequence for the old integer_id column
    execute "DROP SEQUENCE IF EXISTS users_id_seq;"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
