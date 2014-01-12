source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.2'
gem 'arel'

gem 'pg'

# https://github.com/hiravgandhi/angularjs-rails
gem 'angularjs-rails'
gem 'jquery-rails'

gem 'devise', '>= 3.0.2'
gem 'devise-async'
gem 'cancan'

gem 'delayed_job_active_record', '>= 4.0.0.beta1'
gem 'delayed_job_web', '>= 1.2.0'

gem 'handy', github: 'bigbinary/handy'

gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'

gem 'simple_form'

gem 'activeadmin', github: 'gregbell/active_admin'

gem 'unicorn-rails'
gem 'state_machine'
gem 'pusher'

group :production, :staging do
  gem 'memcachier'
  gem 'dalli'
end

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',   github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem 'minitest-reporters', require: false
  gem 'mocha', require: false
  gem 'simplecov', require: false
end

#group :chef do
#  gem 'chef'
#  gem 'knife-solo'
#  gem 'knife-solo_data_bag'
#  gem 'rake'
#  gem 'berkshelf'
#end

group :deploy do
  gem 'j-cap-recipes'
  gem 'capistrano', github: 'capistrano/capistrano'
  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
  gem 'capistrano-rails', github: 'capistrano/rails'
  gem 'capistrano-bundler', github: 'capistrano/bundler'
  gem 'sshkit', github: 'leehambley/sshkit'
end
