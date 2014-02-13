require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  fixtures :nodes, :projects, :users

  setup do
    sign_in users(:john)
    @project = projects(:bidder)
    @another_project = projects(:willow)

    @node = nodes(:amazon)
    @another_node = nodes(:rackspace)
  end

  test 'should get index' do
    get :index, project_id: @project.id
    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test 'should get new' do
    get :new, project_id: @project.id
    assert_response :success
  end

  test 'should create node' do
    assert_difference('Node.count') do
      post :create, node: { name: 'Donetsk Node', hostname: 'localhost' },
                    project_id: @project.id
    end

    assert_equal @project, assigns(:node).project
    assert_redirected_to project_nodes_path(@project)
  end

  test 'should show self node' do
    get :show, id: @node
    assert_response :success
  end

  test 'should not allow show foreign nodes' do
    get :show, id: @another_node
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should get edit' do
    get :edit, id: @node
    assert_response :success
  end

  test 'should not allow edit foreign node' do
    get :edit, id: @another_node
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should update node name' do
    patch :update, id: @node, node: { name: 'Sweet' }
    @node.reload
    assert_equal 'Sweet', @node.name
  end

  test 'should update node user' do
    patch :update, id: @node, node: { user: 'admin' }
    @node.reload
    assert_equal 'admin', @node.user
  end

  def test_update_node_config
    patch :update, id: @node, node: { config: '{"new_attribute": "Time"}' }
    @node.reload
    assert_equal '{"new_attribute": "Time"}', @node.config
  end

  test 'should redirect to nodes list after update' do
    patch :update, id: @node, node: { name: 'Sweet' }
    assert_redirected_to project_nodes_path(@node.project)
  end

  test 'should not allow update foreign nodes' do
    patch :update, id: @another_node, node: { name: 'Haos' }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should destroy node' do
    assert_difference('Node.count', -1) do
      delete :destroy, id: @node
    end

    assert_redirected_to project_nodes_path(@node.project)
  end

  test 'should not allow destroy foreign node' do
    assert_difference('Node.count', 0) do
      delete :destroy, id: @another_node
    end

    assert_redirected_to root_url
  end

end

