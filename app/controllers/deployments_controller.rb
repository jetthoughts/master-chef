class DeploymentsController < UserBaseController
  before_filter :load_projects
  before_filter :load_deployment, only: [:show]
  before_filter :load_project, only: [:show]
  before_action :load_node, only: [:create]

  def index
    @project = Project.find(params[:project_id])

    authorize! :read, @project
    @deployments = @project.deployments
  end

  def show
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

  def load_project
    @project = @deployment.project
  end

  def load_deployment
    @deployment = Deployment.find(params[:id])
  end

end
