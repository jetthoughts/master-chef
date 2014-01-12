set :branch, 'master'
set :stage, :production

server '95.85.35.193',
       user: 'deployer',
       roles: %w{web app db},
       ssh_options: {
           port:          22,
           user:          'deployer',
           auth_methods:  %w(publickey),
           forward_agent: true
       }

set :rails_env, 'production'
fetch(:default_env).merge!(rails_env: :production, path: '/usr/bin:$PATH')
