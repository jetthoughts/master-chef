class BoxBuilder

  include SystemCommand
  include SshKeyHelpers

  attr_reader :base_folder, :logger

  attr_reader :nodes
  attr_reader :selected_node
  attr_accessor :verbose

  def initialize(base_folder, logger, node=nil)
    @logger      = logger
    @base_folder = base_folder
    @verbose = false
    @selected_node = node
    @nodes = []
    init_nodes
  end

  def build
    add_public_key_to_bag
    nodes.each &:build
  end

  private

  def add_public_key_to_bag
    if public_key base_folder
      system_cmd "bundle exec knife solo data bag create keys deployer -d --data-bag-path data_bags -j '{\"id\": \"deployer\", \"authorized_keys\": \"#{public_key base_folder}\"}'"
    end
  end

  def init_nodes
    return @nodes unless @nodes.empty?

    settings_file = File.join(base_folder, 'config', 'settings.yml')

    unless File.exist? settings_file
      log "Config file `config/settings.yml` is missing. Execute below command to copy a sample file."
      log "cp config/settings.yml.example config/settings.yml"
      log "Do not forget to change the ip address and the root password in config/settings.yml"
      exit 1
    end

    configs = YAML::load_file settings_file

    if @selected_node
      configs.delete_if {|key, value| key != @selected_node }
    end

    configs.each do |node, options|
      @nodes << NodeBuilder.new(base_folder, logger, node, options)
    end
  end

end

