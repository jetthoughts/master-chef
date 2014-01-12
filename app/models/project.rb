class Project < ActiveRecord::Base
  belongs_to :user
  has_many :roles
  has_many :nodes, inverse_of: :project
  has_many :deployments, through: :nodes

  validates :title, presence: true, uniqueness: { scope: :user_id }

  def base_folder
    Rails.root.join('projects', user_id.to_s, title.parameterize)
  end

  def update_cookbooks
    chef_project_generator.start

    self.cookbooks_lock = chef_project_generator.update_cookbooks
    self.save!
  end

  private

  def chef_project_generator
    @_chef_project_generator = ChefProjectGenerator.new project_path: base_folder
  end
end
