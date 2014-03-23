class AccountMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  validates :user, presence: true, uniqueness: { scope: :account_id }
  validates :role, presence: true
end
