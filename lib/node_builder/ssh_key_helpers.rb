module SshKeyHelpers

  def default_ssh_key(base_folder)
    File.join(base_folder, '.chef/id_rsa.pem')
  end

  def private_key_path
    return @private_key_path if @private_key_path

    @private_key_path = "#{ENV['HOME']}/.ssh/id_rsa"

    unless File.exist? @private_key_path
      @private_key_path = default_ssh_key
      generate_ssh_key @private_key_path
    end

    @private_key_path
  end

  def public_key_path
    @public_key_path ||= "#{private_key_path}.pub"
  end

  def public_key
    @public_key ||= File.read(public_key_path).chop!
  end

  def generate_ssh_key(path)
    system_cmd "rm -f #{path}{.pub,}"
    system_cmd "ssh-keygen -f #{path} -t rsa -N ''"
  end

  def net_ssh_grant_access
    ssh_options = {}
    ssh_options[:password] = self.password unless self.password.nil?

    Net::SSH.start(self.hostname, self.user, ssh_options) do |session|

      if !password.nil?
        session.exec!("mkdir -p .ssh")
        session.exec!("chmod 0700 .ssh")
        session.exec!("touch .ssh/authorized_keys")
        session.exec!("echo '#{public_key}' >> .ssh/authorized_keys")
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

  def net_ssh_revoke_access
    Net::SSH.start(self.hostname, self.user, password: self.password) do |session|
      session.exec!("sed -i.bak '$d' .ssh/authorized_keys")
      log 'Removing the sudoers file....'
      #TODO: use pty channel
      #session.exec!("sudo rm -f /etc/sudoers.d/zchef-installer") if self.user != 'root'
    end
  end

  def reset_known_host
    system_cmd "ssh-keygen -R #{self.hostname}", ">> Reset known host\n"
  end
end
