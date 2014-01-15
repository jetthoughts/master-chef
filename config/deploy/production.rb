set :branch, 'master'
set :stage, :production

server 'masterchef',
       roles: %w{web app db}

set :rails_env, 'production'
fetch(:default_env).merge!(rails_env: :production)
after 'deploy:check', 'config/settings/production.yml'
