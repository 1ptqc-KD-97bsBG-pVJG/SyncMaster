class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    # all projects with status less than 7
    @active_projects = Project.where("status < 7")
  end

  def show
    @project = Project.find(params[:id])
    @appointments = @project.appointments

    @user = current_user
    if @user.role == 3
      render :show_customer and return
    end

    render :show
  end

  def completed
    @completed_projects = Project.where("status = 7 OR status = 8")
    @current_monday = Time.zone.now.beginning_of_week
    @current_month = Time.zone.now.beginning_of_month
  end

  def canceled
    @canceled_projects = Project.where("status = 9")
    @current_monday = Time.zone.now.beginning_of_week
    @current_month = Time.zone.now.beginning_of_month
  end

  def deleted
    @deleted_projects = Project.where("status = 10")
    @current_monday = Time.zone.now.beginning_of_week
    @current_month = Time.zone.now.beginning_of_month
  end
  
  def download_ical
     project = Project.find(params[:id])
     ical_content = IcalService.generate_project_event(project)

     respond_to do |format|
      format.ics {
        send_data ical_content, type: 'text/calendar', disposition: 'attachment', filename: "#{project.name}.ics"
      }
     end
 end

 before_action :set_project, only: [:update, :update_video, :close, :request_revision]

  def update
    if @project.update(project_params)
      redirect_to @project.appointment, notice: 'Project updated successfully'
    else
      redirect_to @project.appointment, alert: 'Failed to update project'
    end
  end

  def update_video
    if @project.update(video_params)
      redirect_to @project.appointment, notice: 'Video link updated successfully'
    else
      redirect_to @project.appointment, alert: 'Failed to update video link'
    end
  end

  def close
    if @project.update(
      closed_by_id: current_user.id,
      closed_at: Time.current,
      status: 'closed'
    )
      redirect_to @project.appointment, notice: 'Project closed successfully'
    else
      redirect_to @project.appointment, alert: 'Failed to close project'
    end
  end

  def request_revision
    if @project.update(
      revision_requested: true,
      status: 'revision_requested'
    )
      redirect_to @project.appointment, notice: 'Revision requested successfully'
    else
      redirect_to @project.appointment, alert: 'Failed to request revision'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
 Check warning on line 46 in app/controllers/projects_controller.rb

  end

  def project_params
    params.require(:project).permit(:video_link, :video_embedded, :status)
  end

  def video_params
    params.require(:project).permit(:video_link, :video_embedded)
  end
end