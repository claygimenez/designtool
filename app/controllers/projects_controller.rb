class ProjectsController < ApplicationController
  respond_to :html, :json

  def create
    @project = Project.new(project_params)
    @project.save
    render json: @project
  end

  def index
    @projects = Project.all.limit(3)
  end

  def show
    @projects = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:title)
  end
end
