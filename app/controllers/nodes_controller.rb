class NodesController < ApplicationController

  before_action :load_project, only: %i{ index new create}
  before_action :load_node, only: %i{ show edit update destroy }

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
    flash[:notice] = 'Node successfully created!' if @node.save
    respond_with @node, location: [@project]
  end

  def edit
    authorize! :update, @node
  end

  def update
    authorize! :update, @node
    @node.attributes = node_attributes
    flash[:notice] = 'Node successfully updated' if @node.save
    respond_with @node, location: [@node.project]
  end

  def destroy
    authorize! :destroy, @node
    @node.destroy
    redirect_to @node.project, notice: "Node '#{@node.name}' successfully destroyed"
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
