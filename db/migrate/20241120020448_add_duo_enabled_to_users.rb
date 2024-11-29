class AddDuoEnabledToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :duo_enabled, :boolean, default: false
  end
end
