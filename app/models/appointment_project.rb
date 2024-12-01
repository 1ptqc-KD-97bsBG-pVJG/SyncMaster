class AppointmentProject < ApplicationRecord
  belongs_to :appointment
  belongs_to :project
end