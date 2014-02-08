require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def test_get_home_page
    get :home
    assert_response :success
  end
end
