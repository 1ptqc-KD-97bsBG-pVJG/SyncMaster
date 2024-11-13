class AppointmentsController < ApplicationController
    def index
      @appointments = Appointment.all
    end
  
    def new
      @appointment = Appointment.new
      @appointment.addresses.build
      @appointment.projects.build
      @appointment.user_appointments.build
      @users = User.all
    end
  
    def create
      @appointment = Appointment.new(appointment_params)
      @appointment.created_by_id = current_user.id
  
      if @appointment.save
        redirect_to @appointment, notice: 'Appointment created successfully!'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def show
      @appointment = Appointment.find(params[:id])
    end
  
    def download_ical
        appointment = Appointment.find(params[:id])
        ical_content = IcalService.generate_appointment_event(appointment)
      
        respond_to do |format|
          format.ics do
            send_data ical_content, type: 'text/calendar', disposition: 'attachment', filename: "appointment-#{appointment.id}.ics"
          end
        end
      end
      
  
    private
  
    def appointment_params
      params.require(:appointment).permit(
        :appointment_type,
        :status,
        :customer_name,
        :new_customer,
        :note,
        :scheduled_date,
        :scheduled_start,
        :scheduled_end,
        :created_by,
        :completed_by,
        addresses_attributes: [
          :id, :street, :secondary, :city, :state, :zip, :country, :address_type, :_destroy
        ],
        projects_attributes: [
          :id, :project_name, :description, :note, :status, :target_completion, :delivery_link, :_destroy
        ],
        user_appointments_attributes: [
          :id, :user_id, :_destroy
        ]
      )
    end
  end
  