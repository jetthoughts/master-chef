# Set your full path to application.
base_path = '/data/apps/master_chef'
app_path = "#{base_path}/current"
shared_path = "#{base_path}/shared"
listen "#{shared_path}/tmp/sockets/unicorn.sock", backlog: 64
pid "#{app_path}/tmp/pids/unicorn.pid"

working_directory app_path
stderr_path 'log/unicorn.stderr.log'
stdout_path 'log/unicorn.stdout.log'

# Set unicorn options
worker_processes 2
preload_app true
timeout 60


# Spawn unicorn master worker for user apps (group: apps)
#user 'deploy', 'www-data'

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'production'


GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
