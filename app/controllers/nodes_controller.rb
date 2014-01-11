class NodesController < ApplicationController

  before_action :load_project

  def index
    @nodes = @project.nodes
  end

  def new
    @node = @project.nodes.build
  end

  def create
    @node = @project.nodes.build node_attributes
    if @node.save
      redirect_to project_nodes_path, notice: 'Node successfully created'
    else
      render :new
    end
  end

  private

  def node_attributes
    params.require(:node).permit(:name, :credentials, :config)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

end
