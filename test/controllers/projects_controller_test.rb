require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  fixtures :projects, :users

  setup do
    sign_in users(:john)
    @project = projects(:bidder)
    @another_project = projects(:willow)
  end

  test "should get index" do
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

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show self project" do
    get :show, id: @project
    assert_response :success
  end

  test 'should not allow show foreign projects' do
    get :show, id: @another_project
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test 'should not allow edit foreign projects' do
    get :edit, id: @another_project
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should update project" do
    patch :update, id: @project, project: { title: @project.title }
    assert_redirected_to project_path(assigns(:project))
  end

  test 'should not allow update foreign projects' do
    patch :update, id: @another_project, project: { title: 'Bitwine' }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should not allow destroy foreign project" do
    assert_difference('Project.count', 0) do
      delete :destroy, id: @another_project
    end

    assert_redirected_to root_url
  end
end
