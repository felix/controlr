ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

Dir[File.join(Rails.root, "app", "models", "*")].each {|f| require f}
require 'test_fixtures.rb'

# this needs to go before minitest???!
require 'rails/test_help'

require 'shoulda/datamapper'

class ActiveSupport::TestCase
  include Devise::TestHelpers
end

def logger
  ::Rails.logger
end

def start_transaction
  repository(:default) do
    transaction = DataMapper::Transaction.new(repository)
    transaction.begin
    repository.adapter.push_transaction(transaction)
  end
end

def rollback_transaction
  repository(:default).adapter.pop_transaction.rollback
end

DataMapper.auto_migrate!
require "#{Rails.root}/db/seeds.rb"
