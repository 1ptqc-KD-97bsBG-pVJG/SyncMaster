class Project < ApplicationRecord
  has_many :appointment_projects
  has_many :appointments, through: :appointment_projects

  has_many :user_projects
  has_many :users, through: :user_projects

  accepts_nested_attributes_for :users, allow_destroy: true

  belongs_to :appointment
  belongs_to :closed_by, class_name: 'User', optional: true
  
  STATUSES = ['open', 'pending_review', 'approved', 'closed']
  
  validates :status, inclusion: { in: STATUSES }
  
  def close!(user)
    update!(
      status: 'closed',
      closed_by_id: user.id,
      closed_at: Time.current
    )
    
    # Notify relevant parties
    notify_project_closure
  end
  
  def request_revision!
    update!(
      status: 'open',
      revision_requested: true
    )
    
    # Notify employee
    notify_revision_request
  end
  
  private
  
  def notify_project_closure
    # Send notifications to customer and employees
    ProjectMailer.closure_notification(self).deliver_later
  end
  
  def notify_revision_request
    # Notify assigned employees
    ProjectMailer.revision_requested(self).deliver_later
  end
end