class RolesController < ApplicationController

  before_action :load_project, except: [:show, :edit, :update, :destroy]
  before_action :load_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = @project.roles
  end

  def new
    @role = @project.roles.build
  end

  def create
    @role = @project.roles.build role_attributes
    if @role.save
      redirect_to project_roles_path(@project), notice: 'Role successfully created'
    else
      render :new
    end
  end

  def update
    if @role.update_attributes role_attributes
      redirect_to project_roles_path(@role.project), notice: 'Role successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @role.destroy

    redirect_to project_roles_path(@role.project), notice: 'Role successfully deleted'
  end

  private

  def role_attributes
    params.require(:role).permit(:name, :config)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def load_role
    @role = Role.find(params[:id])
  end

end
