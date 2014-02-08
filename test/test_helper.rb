ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  require 'coveralls'
  Coveralls.wear!('rails')

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    add_filter '/test/'
    add_filter '/config/'

    add_group 'Models', 'app/models'
    add_group 'Mailers', 'app/mailers'
    add_group 'Controllers', 'app/controllers'
    add_group 'Uploaders', 'app/uploaders'
    add_group 'Helpers', 'app/helpers'
    add_group 'Workers', 'app/workers'
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require 'mocha/setup'
