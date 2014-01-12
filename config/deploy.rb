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
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/assets projects}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

set :bundle_flags, '--deployment -j 2'
set :bundle_without, %w{development test deploy}.join(' ')

namespace :deploy do
  #before 'deploy:migrate', 'db:backup'

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

  task :bundle_chef_install do
    on roles(:app) do
      within current_path.join('projects') do
        execute :mv, current_path.join('GemfileChef*'), '.'
        execute :bundle, '--gemfile GemfileChef', '--without', fetch(:bundle_without), fetch(:bundle_flags),
                '--path', fetch(:bundle_path)
      end
    end
  end

  after :publishing, 'deploy:restart'
  after :publishing, 'deploy:bundle_chef_install'
  after :finishing, 'deploy:cleanup'

end
