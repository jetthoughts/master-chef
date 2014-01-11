class ChefProjectGenerator

  BASE_FOLDER = Rails.root.join('projects')
  TEMPLATE_PATH = File.expand_path('../templates', __FILE__)

  attr_accessor :name

  def initialize(name: 'chef', cookbooks: 'site :opscode')
    @name = name
    @cookbooks = cookbooks
  end

  def start
    create_project_folder
    copy_base_files
    create_or_update_cookbook_file
  end

  def project_path
    BASE_FOLDER.join(name)
  end

  private

  def create_project_folder
    %w(nodes roles).each do |dir|
      FileUtils.mkdir_p project_path.join(dir)
    end
  end

  def copy_base_files
    FileUtils.cp_r Dir.glob("#{TEMPLATE_PATH}/.chef"), project_path
  end

  def create_or_update_cookbook_file
    File.open(project_path.join('Berksfile'), 'w') do |file|
      file.write @cookbooks
    end
  end
end
