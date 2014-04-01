require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def test_validate_name_presence
    account = Account.new
    assert account.invalid?
    assert_includes account.errors, :name
  end
end
