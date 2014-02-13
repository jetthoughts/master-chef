ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

MiniTest::Reporters.use!

Dir[File.expand_path('test/support/*.rb')].each { |file| require file }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require 'mocha/setup'
Deployment.any_instance.stubs(:schedule_deploy).returns {logger.log '1'}
