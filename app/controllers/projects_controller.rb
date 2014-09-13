class ProjectsController < UserBaseController

  respond_to :html, :js, :json, :zip

  before_filter :authenticate_user!
  before_filter :load_resource, only: [:show, :update, :destroy, :edit]
  authorize_resource

  def index
    load_projects
  end

  def show
    respond_to do |format|
      format.html do
        return redirect_to([@project, :nodes], notice: 'Add at least one server') if @project.nodes.empty?
        redirect_to([@project, :deployments])
      end

      format.zip do
        send_data 'zipcontent', filename: "#{@project.slug}.zip"
      end
    end
  end

  def edit
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(resource_params)
    flash[:notice] = 'Project successfully created!' if @project.save
    respond_with @project, location: [@project, :nodes]
  end

  def update
    @project.update_attributes resource_params

    respond_with @project
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project '#{@project.title}' successfully destroyed"
  end

  protected

  def begin_of_association_chain
    current_user
  end

  private

  def resource_params
    params.require(:project).permit(:title, :cookbooks)
  end

  def load_resource
    @project = current_user.projects.find(params[:id])
  end
end
