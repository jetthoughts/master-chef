require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  setup do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  def test_successfull_user_registration
    assert_difference('User.count') do
      post :create, {user: {email: "gorbypuff@example.com", first_name: "Nancy", last_name: "Smith",
                            password: "welcome", password_confirmation: "welcome"}}
    end
    assert_redirected_to root_path
  end

  def test_required_parameters
    assert_no_difference('User.count') do
      post :create, {user: {email: "steve@example.com",
                            password: "welcome", password_confirmation: "welcome"}}
    end

    assert_response :success
  end
end
