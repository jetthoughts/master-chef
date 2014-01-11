module SystemCommand

  def log(msg)
    logger.append_log("-----> #{msg.to_s}")
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "#{prompt} #{cmd}"
    logger.append_log(`#{cmd}`)
  end

  def bundle_install
    system_cmd 'bundle install', '>>'
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

end
