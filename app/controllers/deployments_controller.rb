class DeploymentsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @deployments = @project.deployments
  end

  def show
    @deployment = Deployment.find(params[:id])
  end

end
