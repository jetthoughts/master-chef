require 'test_helper'

class DeploymentsControllerTest < ActionController::TestCase
  fixtures :nodes, :users, :projects

  setup do
    Deployment.any_instance.stubs(:start)
    Deployment.any_instance.stubs(:deploy!)
    @user = users(:john)
    sign_in @user
  end

  def test_redirect_to_show_page_after_create_deployment
    node = nodes(:rackspace)
    post :create, node_id: node, project_id: node.project_id
    assert_response :redirect
  end

  def test_unathorize_access_to_deployments
    assert_raise ActionController::RoutingError do
      get :index, project_id: projects(:willow).id
    end
    assert_response :success
  end

  def test_index_with_empty_builds
    Deployment.delete_all
    get :index, project_id: project.id
    assert_response :success
  end

  def test_index_with_initial_builds
    Deployment.any_instance.stubs(:schedule_deploy)
    deployment = Deployment.create! node: nodes(:amazon), user: @user
    assert_equal 'initial', deployment.reload.state

    get :index, project_id: project.id
    assert_response :success
  end

  def test_index_with_unfinished_builds
    Deployment.any_instance.stubs(:schedule_deploy)
    deployment = Deployment.create! node: nodes(:amazon), user: @user, state: 'processing'
    assert_equal 'processing', deployment.reload.state

    get :index, project_id: project.id
    assert_response :success
  end

  private

  def project
    @_project ||= projects(:bidder)
  end
end
