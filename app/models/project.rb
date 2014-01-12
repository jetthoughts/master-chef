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

  def prepare_project
    chef_project_generator.start
  end

  private

  def chef_project_generator
    @_chef_project_generator = ChefProjectGenerator.new project_path: base_folder,
                                                        cookbooks:    cookbooks,
                                                        nodes:        nodes_hash,
                                                        roles:        roles_hash
  end

  def nodes_hash
    items_to_hash(nodes)
  end

  def roles_hash
    items_to_hash(roles)
  end

  def items_to_hash(items)
    items.inject({}) do |hash, item|
      hash[item.parameterized_name] = item.config
      hash
    end
  end
end
