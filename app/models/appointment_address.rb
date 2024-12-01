class AppointmentAddress < ApplicationRecord
  belongs_to :appointment
  belongs_to :address
end