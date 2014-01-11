class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :nodes, inverse_of: :project

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user_id}
end
