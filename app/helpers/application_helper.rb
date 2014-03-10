module ApplicationHelper
  def super_admin_signed_in?
    user_signed_in? && current_user.superadmin?
  end

  def nav_link(text, path, options = {}, &block)
    class_name = ''
    coptions = path.is_a?(Hash) ? path : options
    active_tab = coptions.delete(:active)
    class_name = 'active' if active_tab || current_page?(path)


    content_tag(:li, class: class_name) do
      coptions[:title] = text unless coptions.has_key?(:title)
      link_to(text, path, options, &block)
    end
  end

  def current_version
    MasterChef::Application::VERSION
  end
end
