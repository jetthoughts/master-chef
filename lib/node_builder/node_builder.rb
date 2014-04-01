require 'net/ssh'

class NodeBuilder

  include SystemCommand
  include SshKeyHelpers

  attr_reader :base_folder, :logger

  attr_accessor :options, :node

  def initialize(base_folder, logger, node, options={})
    @logger      = logger
    @base_folder = base_folder
    @node        = node
    @options     = options
  end

  def build
    log "%s %s" % [prompt_style('Started setting up host:'), command_style(node)]

    go_to_project_dir
    #add_public_key_to_bag
    grant_ssh_access
    prepare_host
    setup_host
    cleanup_host
    revoke_ssh_access
  end

  def update_cookbooks
    go_to_project_dir
  end

  def hostname
    options['hostname']
  end

  def user
    options['user']
  end

  def port
    options['port'].blank? ? 22 : options['port'].to_i
  end

  def password
    options['password'].blank? ? nil : options['password']
  end

  def go_to_project_dir
    Dir.chdir(base_folder)
    system_cmd 'bundle install', '>>'
  end

  def add_public_key_to_bag
    if public_key
      system_cmd "bundle exec knife solo data bag create keys deployer -c knife.rb -d "\
                 "--data-bag-path data_bags -j '{\"id\": \"deployer\", \"authorized_keys\": \"#{public_key}\"}'",
                 ">> Adding public key to data_bag:\n"
    end
  end

  def grant_ssh_access
    return if self.user == 'root' && self.password.blank?
    reset_known_host
    net_ssh_grant_access
  end

  def revoke_ssh_access
    return if self.password.nil?
    net_ssh_revoke_access
    reset_known_host
  end

  def setup_host
    command = "bundle exec knife solo cook -N #{node} #{self.user}@#{self.hostname} -p #{port} -i #{private_key_path} -V"
    system_cmd command, "Setup host #{self.hostname}:\n"
  end

  def cleanup_host
    command = "bundle exec knife solo clean #{self.user}@#{self.hostname} -p #{port} -i #{private_key_path} -V"
    system_cmd command, "Clean #{self.hostname}:\n"
  end

  def prepare_host
    command = "bundle exec knife solo prepare -N #{node} #{self.user}@#{self.hostname} -p #{port} -i #{private_key_path} -V"
    system_cmd command,  "Install chef to the host #{node}(#{self.hostname}):\n"
  end

end
