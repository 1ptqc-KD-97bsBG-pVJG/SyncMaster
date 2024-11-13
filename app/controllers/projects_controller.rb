class ProjectsController < ApplicationController
  def download_ical
    project = Project.find(params[:id])
    ical_content = IcalService.generate_project_event(project)

    respond_to do |format|
      format.ics {
        send_data ical_content, type: 'text/calendar', disposition: 'attachment', filename: "#{project.name}.ics"
      }
    end
  end
end
