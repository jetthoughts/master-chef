require 'open3'

module SystemCommand

  def log(msg)
    puts "\e[1;35m-----> \e[1;33m" + msg.to_s + "\e[0m"
    logger.append_log("-----> #{msg.to_s}\n")
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "\e[1;33m#{prompt} \e[0;32m#{cmd}\e[0m"
    Open3.popen2e(environment, cmd) do |i, oe, t|
      oe.each { |line| logger.append_log line }
    end
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

  def environment
    { 'BUNDLE_GEMFILE' => File.join(Dir.pwd,('Gemfile')).to_s }
  end
end
