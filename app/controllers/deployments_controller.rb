class DeploymentsController < ApplicationController

  def index
    authorize! :read, Deployment
    @project = Project.find(params[:project_id])
    @deployments = @project.deployments
  end

  def show
    @deployment = Deployment.find(params[:id])
    authorize! :read, @deployment
  end

end
