class Address < ApplicationRecord
  has_many :appointment_addresses
  has_many :appointments, through: :appointment_addresses
end