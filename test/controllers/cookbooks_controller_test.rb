require 'test_helper'

class CookbooksControllerTest < ActionController::TestCase
  fixtures :projects, :users

  setup do
    sign_in users(:john)

  end

  def test_update_cookbooks_lock
    Timecop.freeze(2008, 12, 31, 0, 0)
    patch :update, project_id: project.id, format: :json
    assert_response :success
    assert_equal '# Time to update cookbooks 2008-12-31 00:00:00 UTC', project.reload.cookbooks_lock
    Timecop.return
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
