require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test 'admin is indeed admin' do
    user = users :admin
    assert user.superadmin?
  end
end
