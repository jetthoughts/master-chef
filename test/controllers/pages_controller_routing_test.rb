require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  fixtures :users

  def test_root_page_for_anonymous
    assert_routing '/', {controller: 'pages', action: 'home'}
  end
end
