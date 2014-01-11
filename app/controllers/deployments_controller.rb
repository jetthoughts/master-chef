class DeploymentsController < ApplicationController

  before_action :load_node, only: :create

  def index
    authorize! :read, Deployment
    @project = Project.find(params[:project_id])
    @deployments = @project.deployments
  end

  def show
    @deployment = Deployment.find(params[:id])
    authorize! :read, @deployment
  end

  def create
    @deployment = @node.deployments.create user: current_user
    redirect_to @deployment
  end

  private

  def load_node
    @node = Node.find(params[:node_id])
  end

end
