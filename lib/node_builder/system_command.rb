require 'open3'

module SystemCommand

  def log(msg)
    format_msg = "\e[1;35m-----> \e[1;33m" + msg.to_s + "\e[0m"
    simple_log format_msg
  end

  def simple_log(msg)
    puts msg
    logger.append_log("#{msg}\n")
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "%s %s" % [prompt_style(prompt), command_style(cmd)]
    Open3.popen2e(environment, cmd) do |i, oe, t|
      oe.each { |line| simple_log line }
    end
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

  def environment
    { 'BUNDLE_GEMFILE' => File.join(Dir.pwd,('Gemfile')).to_s }
  end

  def prompt_style(msg)
    "\e[1;33m#{msg}"
  end

  def command_style(msg)
    "\e[0;32m#{msg}"
  end

end
