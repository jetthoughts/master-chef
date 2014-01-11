class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments, inverse_of: :node

  validates :name, presence: true, uniqueness: { scope: :project_id }, allow_blank: false
  validate :validate_credentials

  def credentials_hash
    YAML.load(credentials)
  end

  def prepare_settings
    config_folder = project.base_folder.join('config')
    FileUtils.mkdir_p config_folder
    File.open(config_folder.join('settings.yml'), 'w') do |file|
      file.write({ name => credentials_hash }.to_yaml)
    end
  end

  private

  def validate_credentials
    self.errors.add(:credentials, 'need to be hash in YAML') if credentials.present? && !YAML.load(credentials).instance_of?(Hash)
  rescue Psych::SyntaxError
    self.errors.add(:credentials, 'need to be valid YAML')
  end
end
