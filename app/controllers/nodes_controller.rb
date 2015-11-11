class NodesController < UserBaseController

  before_action :load_node, only: %i{ show edit update destroy }
  before_action :load_project
  before_action :load_projects

  respond_to :html, :json

  def index
    @nodes = @project.nodes
  end

  def new
    authorize! :create, Node
    @node = @project.nodes.build
  end

  def create
    authorize! :create, Node

    @node = @project.nodes.build node_attributes
    if @node.save
      flash[:notice] = 'Node successfully created!'
      respond_to do |format|
        format.html { redirect_to [@project, :nodes] }
      end
    else
      respond_to do |format|
        format.html { render action: :new }
      end
    end
  end

  def edit
    authorize! :update, @node
  end

  def update
    authorize! :update, @node
    @node.attributes = node_attributes
    if @node.save
      flash[:notice] = 'Node successfully updated'
      respond_to do |format|
        format.html { redirect_to [@project, :nodes] }
      end
    else
      respond_to do |format|
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @node
    @node.destroy
    redirect_to [@project, @node], notice: "Node '#{@node.name}' successfully destroyed"
  end

  def show
    authorize! :read, @node
  end

  private

  def node_attributes
    params.require(:node).permit(:name, :credentials, :config, :hostname, :user, :password, :port)
  end

  def load_project
    @project = params[:project_id] ? Project.find(params[:project_id]) : @node.project
  end

  def load_node
    @node = Node.find(params[:id])
  end
end
