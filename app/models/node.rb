class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments, inverse_of: :node

  validates :name, presence: true, uniqueness: { scope: :project_id }, allow_blank: false
  validate :validate_credentials

  def credentials_hash
    YAML.load(credentials)
  end

  def parameterized_name
    name.parameterize
  end

  private

  def validate_credentials
    self.errors.add(:credentials, 'need to be hash in YAML') if credentials.present? && !YAML.load(credentials).instance_of?(Hash)
  rescue Psych::SyntaxError
    self.errors.add(:credentials, 'need to be valid YAML')
  end

end
