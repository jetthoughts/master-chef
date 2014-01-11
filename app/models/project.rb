class Project < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id}
end
