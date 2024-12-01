class CreateUserProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :user_projects, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :project, null: false, foreign_key: true, type: :uuid
      
      t.timestamps
    end
  end
end
