# app/services/ical_service.rb
class IcalService
  def self.generate_appointment_event(appointment)
    # Create a new calendar
    cal = Icalendar::Calendar.new
    
    # Create the event
    event = Icalendar::Event.new
    
    start_datetime = DateTime.new(
      appointment.scheduled_date.year,
      appointment.scheduled_date.month,
      appointment.scheduled_date.day,
      appointment.scheduled_start.hour,
      appointment.scheduled_start.min,
      0
    )

    end_datetime = DateTime.new(
      appointment.scheduled_date.year,
      appointment.scheduled_date.month,
      appointment.scheduled_date.day,
      appointment.scheduled_end.hour,
      appointment.scheduled_end.min,
      0
    )
    
    event.dtstart = start_datetime
    event.dtend = end_datetime
    
    event.summary = "Appointment with #{appointment.customer_name || 'Client'}"
    event.description = appointment.note
    
    if appointment.addresses.any?
      address = appointment.addresses.first
      event.location = [
        address.street,
        address.secondary,
        address.city,
        address.state,
        address.zip,
        address.country
      ].compact.join(', ')
    end
    
    event.uid = "appointment-#{appointment.id}@yourdomain.com"
    event.dtstamp = DateTime.now
    
    # Add event to calendar
    cal.add_event(event)
    
    cal.to_ical
  end
end