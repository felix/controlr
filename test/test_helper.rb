ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

Dir[File.join(Rails.root, "app", "models", "*")].each {|f| require f}
require 'test_fixtures.rb'

# this needs to go before minitest???!
require 'rails/test_help'

#require 'test_notifier/runner/test_unit'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end
Notifier.default_notifier = :notify_send
DataMapper.auto_migrate!
