class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :nodes, inverse_of: :project
  has_many :deployments, through: :nodes

  validates :title, presence: true, uniqueness: { scope: :user_id }

  def base_folder
    Rails.root.join('projects', user_id.to_s, title.parameterize)
  end
end
