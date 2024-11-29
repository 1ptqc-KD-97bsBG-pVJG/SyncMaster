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
end