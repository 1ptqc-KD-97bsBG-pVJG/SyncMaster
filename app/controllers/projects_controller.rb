class ProjectsController < ApplicationController
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
  end
  
  def project_params
    params.require(:project).permit(:video_link, :video_embedded, :status)
  end
  
  def video_params
    params.require(:project).permit(:video_link, :video_embedded)
  end
end
