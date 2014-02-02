module ApplicationHelper
  def super_admin_signed_in?
    user_signed_in? && current_user.superadmin?
  end

  def nav_link(text, path, condition = false, options = {})
    class_name = ''
    class_name = 'active' if condition || current_page?(path)

    content_tag(:li, class: class_name) do
      options[:title] = text unless options.has_key?(:title)
      link_to(text, path, options)
    end
  end

end
