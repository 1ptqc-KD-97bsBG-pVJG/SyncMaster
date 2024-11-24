class AddNameToUsers < ActiveRecord::Migration[7.1]
  def change
    # First add the column without the null constraint
    add_column :users, :name, :string
    
    # Update existing records
    User.update_all(name: 'User')
    
    # Then add the null constraint
    change_column_null :users, :name, false
  end
end