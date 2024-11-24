class ProjectMailer < ApplicationMailer
  def closure_notification(project)
    @project = project
    @appointment = project.appointment
    
    mail(
      to: [@appointment.customer_email, @appointment.employees.pluck(:email)],
      subject: "Project #{@project.project_name} has been closed"
    )
  end
  
  def revision_requested(project)
    @project = project
    @appointment = project.appointment
    
    mail(
      to: @appointment.employees.pluck(:email),
      subject: "Revision requested for #{@project.project_name}"
    )
  end
end 