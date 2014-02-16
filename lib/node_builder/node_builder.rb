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
    log "Started setting up host: #{node}"

    go_to_project_dir
    add_public_key_to_bag
    grant_ssh_access
    prepare_host
    setup_host
    cleanup_host
    revoke_ssh_access
  end

  def hostname
    options['hostname']
  end

  def user
    options['user']
  end

  def password
    options['password']
  end

  def go_to_project_dir
    Dir.chdir(base_folder)
    system_cmd 'bundle install'
  end

  def add_public_key_to_bag
    if public_key base_folder
      system_cmd "bundle exec knife solo data bag create keys deployer -c knife.rb -d "\
                 "--data-bag-path data_bags -j '{\"id\": \"deployer\", \"authorized_keys\": \"#{public_key base_folder}\"}'",
                 ">> Adding public key to data_bag:\n"
    end
  end

  def grant_ssh_access
    return if self.user == 'root' && self.password.nil?

    # Reset known file
    system_cmd "ssh-keygen -R #{self.hostname}", ">> Reset known host\n"

    # Upload public key
    ssh_options = {}
    ssh_options[:password] = self.password unless self.password.nil?

    Net::SSH.start(self.hostname, self.user, ssh_options) do |session|

      if !password.nil?
        session.exec!("mkdir -p .ssh")
        session.exec!("chmod 0700 .ssh")
        session.exec!("touch .ssh/authorized_keys")
        session.exec!("echo '#{public_key base_folder}' >> .ssh/authorized_keys")
        session.exec!("chmod 0600 .ssh/authorized_keys")
        session.exec!('restorecon -FRvv ~/.ssh')
      end

      if user != 'root'
        log ">> Adding user #{user} to sudo without password...."
        ch = session.open_channel do |channel|
          channel.request_pty

          channel.exec 'sudo -i' do |ch, success|
            raise 'could not execute command' unless success

            # "on_data" is called when the process writes something to stdout
            ch.on_data do |c, data|
              if data.include?("password for #{user}")
                c.send_data "#{self.password}\n"
              else
                c.send_data("echo \"#{self.user} ALL = NOPASSWD: ALL\" > /etc/sudoers.d/zchef-installer ; chmod 0440 /etc/sudoers.d/zchef-installer ; exit\n")
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
    return if self.password.nil?
    Net::SSH.start(self.hostname, self.user, password: self.password) do |session|
      session.exec!("sed -i.bak '$d' .ssh/authorized_keys")
      log 'Removing the sudoers file....'
      #TODO: use pty channel
      #session.exec!("sudo rm -f /etc/sudoers.d/zchef-installer") if self.user != 'root'
    end

    system_cmd "ssh-keygen -R #{self.hostname}", ">> Reset known host\n"
  end

  def setup_host
    command = "bundle exec knife solo cook -N #{node} #{self.user}@#{self.hostname} -i #{private_key_path} -V"
    system_cmd command, ">> Setup host #{self.hostname}:\n"
  end

  def cleanup_host
    command = "bundle exec knife solo clean #{self.user}@#{self.hostname} -i #{private_key_path} -V"
    system_cmd command, ">> Clean #{self.hostname}:\n"
  end

  def prepare_host
    command = "bundle exec knife solo prepare -N #{node} #{self.user}@#{self.hostname} -i #{private_key_path} -V"
    system_cmd command,  ">> Install chef to the host #{node}(#{self.hostname}):\n"
  end

end
