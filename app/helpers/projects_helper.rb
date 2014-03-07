module ProjectsHelper
  def recent_projects
    @_recent_projects ||= current_user.projects.order(:title).load
  end
end
