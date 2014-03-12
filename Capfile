# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
# require 'capistrano/rvm'

set :rbenv_custom_path, '/data/rbenv'
require 'capistrano/rbenv'

# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/console'

require 'j-cap-recipes/check'
require 'j-cap-recipes/deploy'
require 'j-cap-recipes/database'
require 'j-cap-recipes/delayed_job'
require 'j-cap-recipes/log'
require 'j-cap-recipes/monit'
require 'j-cap-recipes/nginx'
require 'j-cap-recipes/rails'
require 'j-cap-recipes/rake'
require 'j-cap-recipes/setup'
require 'j-cap-recipes/unicorn'
require 'j-cap-recipes/handy'
require 'j-cap-recipes/files'
require 'j-cap-recipes/airbrake'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
