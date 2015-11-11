source 'https://rubygems.org'

gem 'rails', github: 'rails/rails'
gem 'rack',  github: 'rack/rack'
gem 'arel',  github: 'rails/arel'
gem 'sprockets', github: 'rails/sprockets'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'coffee-rails', github: 'rails/coffee-rails'
gem 'sass-rails', require: 'sass', github: 'rails/sass-rails'

gem 'pg', platform: :ruby

gem 'jquery-rails'

gem 'devise', github: 'twalpole/devise', branch: 'rails5'
gem 'devise-async'
gem 'cancan'

gem 'delayed_job_active_record', '>= 4.0.0.beta1'

gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'

gem 'simple_form'

gem 'state_machine'
gem 'pusher'
gem 'net-ssh'
gem 'net-scp'


gem 'uglifier', '>= 1.0.3'

# https://github.com/intridea/omniauth-github
gem 'omniauth-github'

# https://github.com/peter-murach/github
gem 'github_api'

# https://github.com/rubyzip/rubyzip
gem 'rubyzip', '>= 1.0.0', require: 'zip'

group :production, :staging do
  gem 'dalli'
  gem 'daemons'
  gem 'newrelic_rpm'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'minitest-reporters', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
  gem 'timecop', require: false
  gem 'rails-controller-testing', github: 'rails/rails-controller-testing'
end

# group :deploy do
#   # gem 'unicorn-rails', platform: :ruby
#   # gem 'j-cap-recipes', github: 'jetthoughts/j-cap-recipes'
#   # gem 'capistrano', github: 'capistrano/capistrano'
#   # gem 'capistrano-rbenv', github: 'capistrano/rbenv'
#   # gem 'capistrano-rails', github: 'capistrano/rails'
#   # gem 'capistrano-bundler', github: 'capistrano/bundler'
#   # gem 'sshkit', github: 'leehambley/sshkit'
# end

gem 'config'
