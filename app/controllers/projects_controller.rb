class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @notes = @project.notes
  end
end
