source 'https://rubygems.org'

gem 'rails', '4.1.0.beta2'
gem 'arel'

gem 'pg'

gem 'jquery-rails'

gem 'devise', '>= 3.0.2'
gem 'devise-async'
gem 'cancan'

gem 'delayed_job_active_record', '>= 4.0.0.beta1'
gem 'delayed_job_web', '>= 1.2.0'

gem 'handy', github: 'miry/handy'

gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'

gem 'simple_form'

gem 'state_machine'
gem 'pusher'
gem 'net-ssh'
gem 'net-scp'
gem 'unicorn-rails'
gem 'airbrake'

group :production, :staging do
  gem 'dalli'
  gem 'daemons'
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sprockets-rails'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'minitest-reporters', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'timecop', require: false
end

group :deploy do
  gem 'j-cap-recipes'
  gem 'capistrano', github: 'capistrano/capistrano'
  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
  gem 'capistrano-rails', github: 'capistrano/rails'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'sshkit', github: 'leehambley/sshkit'
end
