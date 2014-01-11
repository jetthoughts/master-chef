class NodesController < ApplicationController
  before_filter :authenticate_user!
  before_action :load_project, only: %i{ index new create }
  before_action :load_node, only: %i{ show edit update destroy }

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
      redirect_to @project, notice: 'Node successfully created'
    else
      render :new
    end
  end

  def edit
    authorize! :update, @node
  end

  def update
    authorize! :update, @node
    if @node.update node_attributes
      redirect_to @node.project, notice: 'Node successfully updated'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @node
    @node.destroy
    redirect_to @node.project, notice: 'Node successfully updated'
  end

  def show
    authorize! :read, @node
  end

  private

  def node_attributes
    params.require(:node).permit(:name, :credentials, :config)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_node
    @node = Node.find(params[:id])
  end
end
