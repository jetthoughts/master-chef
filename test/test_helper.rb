ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  if ENV['CI']
    require 'coveralls'
    Coveralls.wear!('rails')

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
        SimpleCov::Formatter::HTMLFormatter,
        Coveralls::SimpleCov::Formatter
    ]
  end

  SimpleCov.start 'rails' do
    add_filter '/test/'
    add_filter '/config/'

    add_group 'Workers', '/app/workers'
    add_group 'Services', '/lib/services'
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'timecop'

MiniTest::Reporters.use!

Dir[File.expand_path('test/support/*.rb')].each { |file| require file }

require 'mocha/setup'
