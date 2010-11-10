ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

Dir[File.join(Rails.root, "app", "models", "*")].each {|f| require f}
require 'test_fixtures.rb'

# this needs to go before minitest???!
require 'rails/test_help'

#require 'minitest/unit'
#require 'minitest/spec'
# or just this
#require 'minitest/autorun'
require 'test_notifier/runner/test_unit'
require 'test_notifier/runner/autotest'

require 'shoulda/datamapper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end

DataMapper.auto_migrate!
