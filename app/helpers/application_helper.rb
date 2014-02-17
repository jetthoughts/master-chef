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

  def avatar_url(user, size=40)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
