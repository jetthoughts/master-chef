require 'test_helper'

class CookbooksControllerTest < ActionController::TestCase
  fixtures :projects, :users

  setup do
    sign_in users(:john)

  end

  def test_response_after_update_cookbooks_lock
    patch :update, project_id: project.id, format: :json
    assert_equal ' ', response.body
  end

  private
  def project
    @_project ||= projects(:bidder)
  end
end
