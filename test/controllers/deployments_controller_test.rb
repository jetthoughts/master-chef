require 'test_helper'

class DeploymentsControllerTest < ActionController::TestCase
  fixtures :nodes, :users

  setup do
    sign_in users(:john)
  end

  def test_redirect_to_show_page_after_create_deployment
    node = nodes(:rackspace)
    post :create, node_id: node
    assert_response :redirect
  end

end
