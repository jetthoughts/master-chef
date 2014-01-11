class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id}
end
