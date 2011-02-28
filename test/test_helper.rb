ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

Dir[File.join(Rails.root, "app", "models", "*")].each {|f| require f}
require 'test_fixtures.rb'

# this needs to go before minitest???!
require 'rails/test_help'

class ActiveSupport::TestCase
  include Devise::TestHelpers
end
DataMapper.auto_migrate!
