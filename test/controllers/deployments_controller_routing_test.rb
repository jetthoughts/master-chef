require 'test_helper'

class DeploymentsControllerTest < ActionController::TestCase

  def test_create_deployment_path
    assert_routing({path: '/nodes/1/deployments', method: :post},
                   {controller: 'deployments', action: 'create', node_id: '1'})
  end
end
