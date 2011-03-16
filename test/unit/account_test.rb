require 'test_helper'

class AccountTest < Test::Unit::TestCase

  context 'an Account instance' do
    setup do
      Account.auto_migrate!
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      @account = Account.gen
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
    #should validate_presence_of(:client)
    should have_many(:users)
    should have_many(:domains)

  end
end
