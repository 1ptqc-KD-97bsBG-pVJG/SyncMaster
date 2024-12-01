class CreateAppointmentProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :appointment_projects, id: :uuid do |t|
      t.references :appointment, null: false, foreign_key: true, type: :uuid
      t.references :project, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end