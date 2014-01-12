require 'open3'

module SystemCommand

  def log(msg)
    logger.append_log("-----> #{msg.to_s}\n")
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "#{prompt} #{cmd}"
    Open3.popen2e(cmd) do |i, oe, t|
      oe.each { |line| logger.append_log line }
    end
  end

  def bundle_install
    system_cmd 'bundle install', '>>'
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

end
