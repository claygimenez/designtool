class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier

  def index
    @projects = Project.all
  end
end
