class ProjectsController < ApplicationController
  def index
    @projects = Project.limit(1000)
    render json: @projects
  end
end
