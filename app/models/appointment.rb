class Appointment < ApplicationRecord
enum appointment_type: {
    Initial_Appointment: 0,
    Follow_up: 1,
    Reshoot: 2
}
enum status: {
    Scheduled: 0,
    Completed: 1,
    Canceled: 2
}

    validates :scheduled_date, presence: true
    validates :scheduled_start, presence: true
    validates :scheduled_end, presence: true
    validates :appointment_type, presence: true
    validates :status, presence: true
    validates :note, presence: true

    belongs_to :created_by_user, class_name: 'User', foreign_key: 'created_by_id'
    belongs_to :completed_by_user, class_name: 'User', foreign_key: 'completed_by_id', optional: true

    has_many :user_appointments
    has_many :employees, through: :user_appointments, source: :user

    has_many :appointment_addresses
    has_many :addresses, through: :appointment_addresses

    has_many :appointment_projects
    has_many :projects, through: :appointment_projects

    accepts_nested_attributes_for :addresses, :projects, :user_appointments, allow_destroy: true

end
