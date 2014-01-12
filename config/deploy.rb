set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'

set :application, 'master_chef'
set :repo_url,    'git@github.com:jetthoughts/master-chef.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/data/apps/#{fetch(:application)}"
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system projects}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :bundle_flags, '--deployment -j 3'
set :bundle_without, %w{development test deploy}.join(' ')

namespace :deploy do
  before 'deploy:migrate', 'db:backup'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  #after :restart, :clear_cache do
  #  on roles(:web), in: :groups, limit: 3, wait: 10 do
  #    # Here we can do anything such as:
  #    within release_path do
  #       execute :rake, 'cache:clear'
  #    end
  #  end
  #end

  after :finishing, 'deploy:cleanup'

end
