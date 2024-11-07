class AppointmentsController < ApplicationController
    def index
        @appointments = Appointment.all
    end
    def new
        @appointment = Appointment.new
    end
    def create
        @appointment = Appointment.new(appointment_params)
        @appointment.customer_id = current_user.id
        if @appointment.save
          redirect_to appointments_path, notice: "Appointment was successfully created."
        else
          render :new, alert: "There was an error creating the appointment."
        end
    end
    def show
        @appointment = Appointment.find(params[:id])
    end

    def appointment_params
        params.require(:appointment).permit(:appointment_type, :status, :customer_id, :new_customer, :created_by, :completed_by, :scheduled_date, :scheduled_start, :scheduled_end, :note)
    end
end
  