require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  tests ProjectsController

  fixtures :projects, :users

  setup do
    @user = users(:john)
    sign_in @user
    @project = projects(:bidder)
    @another_project = projects(:willow)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test 'should get index for admin' do
    sign_out @user
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { title: @project.title + 'new' }
    end

    assert_redirected_to project_nodes_path(assigns(:project))
  end

  test 'should redirect to deployments' do
    @project.nodes.create!(name: 'Amazon', hostname: 'example.com')
    get :show, id: @project
    assert_redirected_to project_deployments_path(@project)
  end

  test 'should redirect to nodes if there are no nodes created' do
    @project.nodes.delete_all
    get :show, id: @project
    assert_redirected_to project_nodes_path(@project)
  end

  test 'return success for zip format' do
    get :show, id: @project, format: :zip
    assert_response :success
  end

  test 'send file for zip format' do
    get :show, id: @project, format: :zip
    assert_equal 'application/zip', response.header['Content-Type']
  end

  test 'should not allow show foreign projects' do
    assert_raise ActiveRecord::RecordNotFound do
      get :show, id: @another_project
    end
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @project
    assert_response :success
  end

  test 'should not allow edit foreign projects' do
    assert_raise ActiveRecord::RecordNotFound do
      get :edit, id: @another_project
    end
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { title: @project.title }
    assert_redirected_to project_path(assigns(:project))
  end

  test 'should not allow update foreign projects' do
    assert_raise ActiveRecord::RecordNotFound do
      patch :update, id: @another_project, project: { title: 'Bitwine' }
    end
    assert_response :success
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test 'should not allow destroy foreign project' do
    assert_difference('Project.count', 0) do
      assert_raise ActiveRecord::RecordNotFound do
        delete :destroy, id: @another_project
      end
    end

    assert_response :success
  end
end
