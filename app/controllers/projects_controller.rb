class ProjectsController < InheritedResources::Base
  load_and_authorize_resource

  before_filter :authenticate_user!

  def create
    @project = current_user.projects.build(permitted_params[:project])
    create!
  end

  private

  def permitted_params
    {project: params.fetch(:project, {}).permit(:title, :cookbooks)}
  end

end
