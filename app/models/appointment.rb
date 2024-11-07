class Appointment < ApplicationRecord
    validates :scheduled_date, presence: true
    validates :scheduled_start, presence: true
    validates :scheduled_end, presence: true
    validates :appointment_type, presence: true
    validates :status, presence: true
    validates :customer_id, presence: true
    validates :note, presence: true
end
