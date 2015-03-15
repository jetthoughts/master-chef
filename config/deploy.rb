set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.1'

set :application, 'master_chef'
set :repo_url,    'git@github.com:jetthoughts/master-chef.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/data/apps/#{fetch(:application)}"
set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml  config/newrelic.yml}
set :linked_dirs, %w{log tmp vendor/bundle public/assets projects config/settings}

set :default_env, { path: '/data/rbenv/shims:/data/rbenv/bin:/data/rbenv/plugins/ruby_build/bin:/usr/bin:$PATH' }
set :keep_releases, 5

set :bundle_flags, '--deployment -j 2'
set :bundle_without, %w{development test deploy}.join(' ')

namespace :deploy do
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

set :build_number, proc { [fetch(:current_revision), Time.now.strftime("%Y%m%d"), ].compact.join('-') }
after 'deploy:log_revision', 'deploy:update_version'
