class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :nodes, inverse_of: :project
  has_many :deployments, through: :nodes

  validates :title, presence: true, uniqueness: { scope: :user_id }

  def update_cookbooks
    chef_project.update_cookbooks
  end

  def prepare_project
    chef_project.prepare
  end
  deprecate :prepare_project

  private

  def chef_project
    @_chef_project ||= ChefProject.new(project)
  end
end
