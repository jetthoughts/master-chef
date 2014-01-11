class NodesController < ApplicationController

  before_action :load_project, only: %i{ index new create }
  before_action :load_node, only: %i{ show edit update destroy }

  def index
    @nodes = @project.nodes
  end

  def new
    @node = @project.nodes.build
  end

  def create
    @node = @project.nodes.build node_attributes
    if @node.save
      redirect_to @project, notice: 'Node successfully created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @node.update node_attributes
      redirect_to @node.project, notice: 'Node sucessfully updated'
    else
      render :edit
    end
  end

  def destroy
    @node.destroy
    redirect_to @node.project, notice: 'Node sucessfully updated'
  end

  def show
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
