module SystemCommand

  def log(msg)
    puts "\e[1;35m-----> \e[1;33m" + msg.to_s + "\e[0m"
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "\e[1;33m#{prompt} \e[0;32m#{cmd}\e[0m"
    system cmd
  end

  def bundle_install
    system_cmd 'bundle install', '>>'
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

end
