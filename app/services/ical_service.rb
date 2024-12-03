# app/services/ical_service.rb
class IcalService
  def self.generate_appointment_event(appointment)
    # Create a new calendar
    cal = Icalendar::Calendar.new

    # Create the event
    event = Icalendar::Event.new
    event.dtstart = appointment.scheduled_start.strftime("%Y%m%dT%H%M%S")
    event.dtend = appointment.scheduled_end.strftime("%Y%m%dT%H%M%S")
    event.summary = "Appointment with #{appointment.customer_name || 'Client'}"
    event.description = appointment.note || "No additional notes"
    
    # Required properties
    event.uid = "appointment-#{appointment.id}@yourdomain.com"
    event.dtstamp = DateTime.now.strftime("%Y%m%dT%H%M%S")
    
    # Add event to calendar
    cal.add_event(event)
    
    # Return the formatted calendar string
    cal.to_ical
  end

  def self.generate_project_event(project)
    # Create a new calendar
    cal = Icalendar::Calendar.new
    
    # Create the event
    event = Icalendar::Event.new
    event.dtstart = project.target_completion.strftime("%Y%m%dT%H%M%S")
    event.summary = project.project_name
    event.description = project.description || "No description provided"
    
    # Required properties
    event.uid = "project-#{project.id}@yourdomain.com"
    event.dtstamp = DateTime.now.strftime("%Y%m%dT%H%M%S")
    
    # Add event to calendar
    cal.add_event(event)
    
    # Return the formatted calendar string
    cal.to_ical
  end
end