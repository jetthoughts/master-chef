class ProjectsController < InheritedResources::Base
  before_filter :load_projects
  load_and_authorize_resource

  def create
    @project = current_user.projects.build(permitted_params[:project])
    create!
  end

  protected

  def begin_of_association_chain
    current_user
  end

  private

  def permitted_params
    {project: params.fetch(:project, {}).permit(:title, :cookbooks)}
  end

  def load_projects
    @projects = current_user.projects.order(:title)
  end

end
