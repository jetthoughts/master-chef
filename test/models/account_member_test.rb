require 'test_helper'

class AccountMemberTest < ActiveSupport::TestCase
  def test_require_user
    subject = AccountMember.new
    assert subject.invalid?
    assert_includes subject.errors, :user
  end

  def test_require_role
    subject = AccountMember.new
    assert subject.invalid?
    assert_includes subject.errors, :role
  end

end
