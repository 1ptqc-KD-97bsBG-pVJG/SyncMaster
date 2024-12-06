class GoogleCalendarService
  def self.generate_google_calendar_link(appointment)
    base_url = "https://calendar.google.com/calendar/render"
    
    params = {
      action: 'TEMPLATE',
      text: format_title(appointment),
      details: format_details(appointment),
      dates: format_dates(appointment),
      location: format_location(appointment)
    }

    "#{base_url}?#{params.to_query}"
  end

  private

  def self.format_title(appointment)
    customer_name = appointment.customer_name.present? ? " - #{appointment.customer_name}" : ""
    "SyncMaster Appointment#{customer_name}"
  end

  def self.format_dates(appointment)
    # Convert to UTC format that Google Calendar expects
    start_time = appointment.scheduled_date.to_date.to_time.change(
      hour: appointment.scheduled_start.hour,
      min: appointment.scheduled_start.min
    )
    
    end_time = appointment.scheduled_date.to_date.to_time.change(
      hour: appointment.scheduled_end.hour,
      min: appointment.scheduled_end.min
    )

    "#{start_time.strftime('%Y%m%dT%H%M%S')}/#{end_time.strftime('%Y%m%dT%H%M%S')}"
  end

  def self.format_location(appointment)
    return "" unless appointment.addresses.any?
    address = appointment.addresses.first
    [address.street, address.city, address.state, address.zip].compact.join(', ')
  end

  def self.format_details(appointment)
    details = []
    details << "Type: #{appointment.appointment_type}"
    details << "Status: #{appointment.status}"
    details << "Note: #{appointment.note}"
    
    if appointment.employees.any?
      details << "\nAssigned Employees:"
      appointment.employees.each do |employee|
        details << "- #{employee.email}"
      end
    end

    if appointment.projects.any?
      details << "\nProjects:"
      appointment.projects.each do |project|
        details << "- #{project.project_name}"
        details << "  Description: #{project.description}"
        details << "  Note: #{project.note}"
      end
    end

    details.join("\n")
  end
end 