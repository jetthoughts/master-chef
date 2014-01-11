class DeploymentsController < ApplicationController
  inherit_resources

  def create
    @deployment = current_user.deployments.build(permitted_params[:deployment])
    create!
  end

  private

  def permitted_params
    { deployment: params.fetch(:deployment, {}).permit(:node_id, :project_id) }
  end

end
