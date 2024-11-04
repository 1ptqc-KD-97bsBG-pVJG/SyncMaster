class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :project_name, null: false
      t.text :description
      t.text :note
      t.integer :status
      t.datetime :target_completion
      t.string :delivery_link
      t.timestamps
    end
  end
end
