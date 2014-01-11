module SshKeyHelpers
  BASE_DIR = File.realpath(File.join(File.dirname(__FILE__), '..'))
  DEFAULT_SSH_KEY = File.join(BASE_DIR, '.chef/id_rsa.pem')

  def private_key_path
    return @private_key_path if @private_key_path

    @private_key_path = "#{ENV['HOME']}/.ssh/id_rsa"

    unless File.exist? @private_key_path
      generate_ssh_key(SshKeyHelpers::DEFAULT_SSH_KEY)
      @private_key_path = SshKeyHelpers::DEFAULT_SSH_KEY
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

end
