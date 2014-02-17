class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def load_project
    @project ||= Project.find params[:project_id]
  end

  def load_projects
    @projects = current_user.projects.order(:title)
  end

  def after_sign_in_path_for(resource)
    #stored_location_for(resource) || projects_path
    projects_path
  end

  def after_sign_up_path_for(resource)
    projects_path
  end

end
