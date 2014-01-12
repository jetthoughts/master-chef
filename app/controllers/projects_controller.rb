class ProjectsController < InheritedResources::Base
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

end
