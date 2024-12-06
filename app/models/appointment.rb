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
  
    def start_datetime
      return nil unless scheduled_date && scheduled_start
      DateTime.new(
        scheduled_date.year,
        scheduled_date.month,
        scheduled_date.day,
        scheduled_start.hour,
        scheduled_start.min,
        0,
        Time.zone.utc_offset
      )
    end
  
    def end_datetime
      return nil unless scheduled_date && scheduled_end
      DateTime.new(
        scheduled_date.year,
        scheduled_date.month,
        scheduled_date.day,
        scheduled_end.hour,
        scheduled_end.min,
        0,
        Time.zone.utc_offset
      )
    end
  
    validate :end_time_after_start_time
  
    private
  
    def end_time_after_start_time
      return if scheduled_start.blank? || scheduled_end.blank?
      
      if scheduled_end < scheduled_start
        errors.add(:scheduled_end, "must be after the start time")
      end
    end
  end