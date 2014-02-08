class RolesController < UserBaseController
  before_filter :load_projects
  before_action :load_project, except: [:show, :edit, :update, :destroy]
  before_action :load_role, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, @project
    @roles = @project.roles
  end

  def show
    authorize! :read, @role
  end

  def new
    authorize! :create, Role
    @role = @project.roles.build
  end

  def create
    authorize! :create, Role
    @role = @project.roles.build role_attributes
    if @role.save
      redirect_to @project, notice: 'Role successfully created'
    else
      render :new
    end
  end

  def edit
    authorize! :update, @role
  end

  def update
    authorize! :update, @role
    if @role.update_attributes role_attributes
      redirect_to @role.project, notice: 'Role successfully updated'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @role
    @role.destroy

    redirect_to @role.project, notice: 'Role successfully deleted'
  end

  private

  def role_attributes
    params.require(:role).permit(:name, :config)
  end

  def load_project
    @project = @projects.find(params[:project_id])
  end

  def load_role
    @role = Role.find(params[:id])
  end

end
