class ChefProject
  cattr_accessor :base_folder
  attr_accessor :project

  def initialize(project)
    @project = project
  end

  def update_cookbooks!
    prepare
    lock_file_path = project_path.join('Berksfile.lock')
    @project.cookbooks_lock = File.read(lock_file_path) if File.exist?(lock_file_path)
    @project.save!
  end

  def prepare
    chef_project_generator.start
  end

  def self.base_folder
    @@base_folder || Rails.root.join('projects')
  end

  def base_folder
    self.class.base_folder
  end

  def project_path
    base_folder.join(@project.user_id.to_s, @project.slug)
  end

  def build_node(node, logger)
    NodeBuilder.new(project_path,
                    logger,
                    node.name.parameterize,
                    node.credentials).build

  end

  def archive
    prepare
    path = project_path.to_s
    path.sub!(%r[/$],'')
    archive_name = base_folder.join(@project.user_id.to_s, "#{project.slug}.zip").to_s
    FileUtils.rm archive_name, :force=>true

    Zip::File.open(archive_name, 'w') do |zipfile|
      Dir["#{path}/**/*"].each do |file|
        zipfile.add(file.sub(path + '/', ''), file)
      end
    end
    archive_name
  end
  private

  def chef_project_generator
    @_chef_project_generator ||= ChefProjectGenerator.new project_path: project_path,
                                                          cookbooks:    @project.cookbooks,
                                                          nodes:        nodes_hash,
                                                          roles:        roles_hash
  end

  def nodes_hash
    items_to_hash(@project.nodes)
  end

  def roles_hash
    items_to_hash(@project.roles)
  end

  def items_to_hash(items)
    items.inject({}) do |hash, item|
      hash[item.parameterized_name] = item.config
      hash
    end
  end

end
