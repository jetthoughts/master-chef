class NodeBuilder

  include SystemCommand
  include SshKeyHelpers

  attr_reader :base_folder, :logger

  attr_accessor :options, :node

  def initialize(base_folder, logger, node, options={})
    @logger = logger
    @base_folder = base_folder
    @node    = node
    @options = options

    init_node_config
  end

  def build
    log "started setting up host: #{node}"

    grant_ssh_access
    prepare_host
    setup_host
    cleanup_host
    revoke_ssh_access
  end

  def grant_ssh_access
    return if options['user'] == 'root' && options['password'].nil?

    # Reset known file
    system_cmd "ssh-keygen -R #{options['hostname']}", ">> Reset known host\n"

    # Upload public key
    ssh_options = {}
    ssh_options[:password] = options['password'] unless options['password'].nil?

    Net::SSH.start(options['hostname'], options['user'], ssh_options) do |session|

      if !options['password'].nil?
        session.exec!("mkdir -p .ssh")
        session.exec!("chmod 0700 .ssh")
        session.exec!("touch .ssh/authorized_keys")
        session.exec!("echo '#{public_key}' >> .ssh/authorized_keys")
        session.exec!("chmod 0600 .ssh/authorized_keys")
      end

      if options['user'] != 'root'
        puts ">> Adding user #{options['user']} to sudo without password...."
        ch = session.open_channel do |channel|
          channel.request_pty

          channel.exec 'sudo -i' do |ch, success|
            raise 'could not execute command' unless success

            # "on_data" is called when the process writes something to stdout
            ch.on_data do |c, data|
              if data.include?("password for #{options['user']}")
                c.send_data "#{options['password']}\n"
              else
                c.send_data("echo \"#{options['user']} ALL = NOPASSWD: ALL\" > /etc/sudoers.d/zchef-installer ; chmod 0440 /etc/sudoers.d/zchef-installer ; exit\n")
              end
            end

            # "on_extended_data" is called when the process writes something to stderr
            ch.on_extended_data do |c, type, data|
              $STDERR.print data
            end

            ch.on_close { puts "done!" }
          end
        end

        ch.wait
      end
    end
  end

  def revoke_ssh_access
    return if options['password'].nil?
    Net::SSH.start(options['hostname'], options['user'], password: options['password']) do |session|
      session.exec!("sed -i.bak '$d' .ssh/authorized_keys")
      log 'Removing the sudoers file....'
      #TODO: use pty channel
      #session.exec!("sudo rm -f /etc/sudoers.d/zchef-installer") if options['user'] != 'root'
    end

    system_cmd "ssh-keygen -R #{options['hostname']}", ">> Reset known host\n"
  end

  def setup_host
    command = "bundle exec knife solo cook -N #{node} #{options['user']}@#{options['hostname']} -i #{private_key_path base_folder} -V"
    system_cmd command, ">> Setup host #{options['hostname']}:\n"
  end

  def cleanup_host
    command = "bundle exec knife solo clean #{options['user']}@#{options['hostname']} -i #{private_key_path base_folder} -V"
    system_cmd command, ">> Clean #{options['hostname']}:\n"
  end

  def init_node_config
    stack_file_template = File.join(base_folder, 'roles', "#{options['stack']}.json")
    node_config_file = config_file_path

    unless File.exist? stack_file_template
      log "Config file `#{stack_file_template}` is missing. Execute below command to copy a sample file."
      log "cp roles/rails-stack.json.example roles/#{options['stack']}.json"
      exit 1
    end

    command = "cp -n #{stack_file_template} #{node_config_file}"
    system_cmd command, ">> Create node config file:\n"
  end

  def prepare_host
    command = "bundle exec knife solo prepare -N #{node} #{options['user']}@#{options['hostname']} -i #{private_key_path base_folder} -V"
    system_cmd command,  ">> Install chef to the host #{node}(#{options['hostname']}):\n"
  end

  def config_file_path
    File.join(base_folder, 'nodes', "#{node}.json")
  end

end
