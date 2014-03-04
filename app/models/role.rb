class Role < ActiveRecord::Base
  belongs_to :project

  validates :name, presence: true, uniqueness: { scope: :project_id }
  validates :project, presence: true

  after_initialize do
    self.config ||= default_config
  end

  def parameterized_name
    name.parameterize
  end


  private
  def default_config
    <<END
{
  // You can find examples in: http://bit.ly/1kDPBpu

  "name": "<role_name>",
  "description": "<role description>",
  "default_attributes": {
    // Role default attributes
  },

  "json_class": "Chef::Role",
  "run_list": [],
  "chef_type": "role",
  "override_attributes": { }
}

END
  end

end
