class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments, inverse_of: :node

  store :credentials, accessors: %i{ hostname user password }
  validates :name, presence: true, uniqueness: { scope: :project_id }, allow_blank: false
  validates :hostname, :user, presence: true
  validate :config_is_json_format

  after_initialize do
    self.user   ||= 'root'
    self.config ||= default_config
  end

  def parameterized_name
    name.parameterize
  end

  def to_s
    name
  end

  private

  def config_is_json_format
    JSON.parse(self.config)
  rescue JSON::ParserError
    errors[:config] << 'not in json format'
  end

  private

  def default_config
<<END
{
  // You can find examples in: http://bit.ly/1kDPBpu
  "run_list": [
    "recipe[chef-solo-search]"
  ]
}
END
  end
end
