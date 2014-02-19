module ProjectsHelper
  def recent_projects
    @_recent_projects ||= current_user.projects.order(:title).all
  end
end
