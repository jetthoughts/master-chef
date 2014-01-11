ENV["RAILS_ENV"] ||= "test"
require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'

  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Controllers', 'app/controllers'
  add_group 'Uploaders', 'app/uploaders'
  add_group 'Helpers', 'app/helpers'
  add_group 'Workers', 'app/workers'
end if ENV['COVERAGE']

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'mocha/setup'


MiniTest::Reporters.use!


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end
