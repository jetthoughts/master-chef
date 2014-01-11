module SshKeyHelpers

  def default_ssh_key(base_folder)
    File.join(base_folder, '.chef/id_rsa.pem')
  end

  def private_key_path(base_folder)
    return @private_key_path if @private_key_path

    @private_key_path = "#{ENV['HOME']}/.ssh/id_rsa"

    unless File.exist? @private_key_path
      generate_ssh_key default_ssh_key(base_folder)
      @private_key_path = default_ssh_key(base_folder)
    end

    @private_key_path
  end

  def public_key_path(base_folder)
    @public_key_path ||= "#{private_key_path base_folder}.pub"
  end

  def public_key(base_folder)
    @public_key ||= File.read(public_key_path base_folder).chop!
  end

  def generate_ssh_key(path)
    system_cmd "rm -f #{path}{.pub,}"
    system_cmd "ssh-keygen -f #{path} -t rsa -N ''"
  end

end
