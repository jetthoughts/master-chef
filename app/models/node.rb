class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments, inverse_of: :node

  validates :name, presence: true, uniqueness: { scope: :project_id }
  validate :validate_credentials

  private

  def validate_credentials
    self.errors.add(:credentials, 'need to be hash in YAML') unless YAML.load(credentials).instance_of? Hash
  rescue Psych::SyntaxError
    self.errors.add(:credentials, 'need to be valid YAML')
  end
end
