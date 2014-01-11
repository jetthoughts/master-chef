class ChefProjectGenerator

  BASE_FOLDER = Rails.root.join('projects')
  TEMPLATE_PATH = File.expand_path('../templates', __FILE__)

  attr_accessor :name

  def initialize(name: 'chef', cookbooks: 'site :opscode', nodes: {}, roles: {})
    @name = name
    @cookbooks = cookbooks
    @nodes = nodes
    @roles = roles
  end

  def start
    create_project_folder
    copy_base_files
    create_or_update_cookbook_file
    create_or_update_nodes
    create_or_update_roles
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
    create_or_update_file('Berksfile', @cookbooks)
  end

  def create_or_update_nodes
    @nodes.each do |file_name, content|
      create_or_update_file("nodes/#{file_name}.json", content)
    end
  end

  def create_or_update_roles
    @roles.each do |file_name, content|
      create_or_update_file("roles/#{file_name}.json", content)
    end

  end

  def create_or_update_file(file_path, content)
    File.open(project_path.join(file_path), 'w') do |file|
      file.write content
    end
  end


end
