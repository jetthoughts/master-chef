require 'open3'

module SystemCommand

  class FailedCommandException < StandardError; end

  def log(msg)
    format_msg = "\e[1;35m-----> \e[1;33m" + msg.to_s + "\e[0m\n"
    simple_log format_msg
  end

  def simple_log(msg)
    print msg
    logger.append_log(msg)
  end

  def system_cmd(cmd, prompt='COMMAND:')
    log "%s %s" % [prompt_style(prompt), command_style(cmd)]
    log "with environment: #{environment.to_s}"

    exec_cmd = "sudo -u #{run_as_user} /bin/bash -l -c 'cd #{@base_folder}; #{cmd}'"
    Open3.popen2e(environment, exec_cmd) do |i, oe, t|
      oe.each { |line| simple_log line }

      raise FailedCommandException, t.value, caller unless t.value.success?
    end
  end

  def berkshelf_update_cookbooks
    system_cmd 'bundle exec berks install --path cookbooks'
  end

  def environment
    { 'BUNDLE_GEMFILE' => "#{@base_folder}/Gemfile", 'GEM_PATH' => nil }
  end

  def prompt_style(msg)
    "\e[1;33m#{msg}"
  end

  def command_style(msg)
    "\e[0;32m#{msg}"
  end

  def run_as_user
    Settings.deployment.user || ENV['USER']
  end
end
