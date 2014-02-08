require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def test_successfull_user_registration
    assert_difference('User.count') do
      post :create, { user: { email: 'gorbypuff@example.com',
                              first_name: 'Nancy',
                              last_name: 'Smith',
                              password: 'welcome',
                              password_confirmation: 'welcome' } }
    end

  end

  def test_after_registration_redirects_to_projects_path
    post :create, { user: { email: 'gorbypuff@example.com',
                            first_name: 'Nancy',
                            last_name: 'Smith',
                            password: 'welcome',
                            password_confirmation: 'welcome' } }

    assert_redirected_to projects_path
  end

  def test_success_registraion_without_name
    assert_difference('User.count') do
      post :create, { user: { email:    'new_email@example.com',
                              password: 'welcome',
                              password_confirmation: 'welcome' } }
    end

    assert_redirected_to projects_path
  end

  def test_uniq_email
    assert_no_difference('User.count') do
      post :create, { user: { email:    'steve@example.com',
                              password: 'welcome',
                              password_confirmation: 'welcome' } }
    end

    assert_includes assigns[:user].errors, :email
    assert_response :success
  end
end
