class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :nodes, inverse_of: :project
  has_many :deployments, through: :nodes

  validates :title, presence: true, uniqueness: { scope: :user_id }

  after_initialize do
    self.cookbooks ||= default_cookbooks
  end

  def update_cookbooks!
    chef_project.update_cookbooks!
  end

  def slug
    '%d_%s' % [id, title.parameterize]
  end

  private

  def chef_project
    @_chef_project ||= ChefProject.new(self)
  end

  def default_cookbooks
    Settings.project.default_cookbooks || ""
  end
end
