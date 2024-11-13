class AddDefaultStatusToAppointmentsAndProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_default :appointments, :status, from: nil, to: 0
    change_column_default :appointments, :appointment_type, from: nil, to: 0
    change_column_default :projects, :status, from: nil, to: 0
  end
end
