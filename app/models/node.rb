class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments, inverse_of: :node

  store :credentials, accessors: %i{ hostname user password }
  validates :name, presence: true, uniqueness: { scope: :project_id }, allow_blank: false
  validates :hostname, :user, presence: true
  validate :config_is_json_format

  after_initialize do
    self.user = 'root'
    self.config = <<END
{
  // Default user created by role machine. This user is required for rails-stack.
  //"user": ["deployer"],

  // Example of Overiding default value for nginx package
  // "nginx": {
  //  "worker_processes": 1
  // },
  //
  // "ruby": {
  //   "version": "2.1.0"
  // },
  //
  // "run_list": [
  // This recipe required for cookbooks that depends on data-bags serach functionality.
  //  "recipe[chef-solo-search]",

  // Setup basic required users, tools and packages for all type of machines
  // "role[machine]",
  // "role[application]",
  // "role[nginx]",
  // "role[pg_ubuntu]",
  // "recipe[memcached]"
  // ]
}
END
  end

  def parameterized_name
    name.parameterize
  end

  def to_s
    name
  end

  private

  def config_is_json_format
    errors[:config] << 'not in json format' unless JSON.parse(self.config)
  end

end
