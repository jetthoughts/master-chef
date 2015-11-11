require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  fixtures :roles, :projects, :users

  setup do
    sign_in users(:john)
    @project = projects(:bidder)
    @another_project = projects(:willow)

    @role = roles(:web)
    @another_role = roles(:db)
  end

  test 'should get index' do
    process :index, method: :get, params: { project_id: @project.id }
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test 'should get new' do
    get :new, project_id: @project.id
    assert_response :success
  end

  test 'should create role' do
    assert_difference('Role.count') do
      post :create, role: { name: 'Redis' },
                    project_id: @project.id
    end

    assert_equal @project, assigns(:role).project
    assert_redirected_to [@project, :roles]
  end

  test 'should show self role' do
    get :show, id: @role
    assert_response :success
  end

  test 'should not allow show foreign roles' do
    assert_raise ActionController::RoutingError do
      get :show, id: @another_role
    end
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @role
    assert_response :success
  end

  test 'should not allow edit foreign role' do
    assert_raise ActionController::RoutingError do
      get :edit, id: @another_role
    end
    assert_response :success
  end

  test 'should update role' do
    patch :update, id: @role, role: { name: 'nginx' }
    assert_redirected_to @role.project
  end

  test 'should not allow update foreign roles' do
    assert_raise ActionController::RoutingError do
      patch :update, id: @another_role, role: {name: 'thin'}
    end
    assert_response :success
  end

  test 'should destroy role' do
    assert_difference('Role.count', -1) do
      delete :destroy, id: @role
    end

    assert_redirected_to @role.project
  end

  test 'should not allow destroy foreign role' do
    assert_difference('Role.count', 0) do
      assert_raise ActionController::RoutingError do
        delete :destroy, id: @another_role
      end
    end

    assert_response :success
  end

end

