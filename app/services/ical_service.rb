# Ensure the class is defined like this:
class IcalService
  def self.generate_appointment_event(appointment)
    event = Icalendar::Event.new

    # Use scheduled_start and scheduled_end attributes
    event.dtstart = appointment.scheduled_start.to_datetime
    event.dtend = appointment.scheduled_end.to_datetime
    event.summary = "Appointment with #{appointment.customer_name || 'Client'}"
    event.description = appointment.note || "No additional notes."

    event
  end
end
