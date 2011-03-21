require 'test_helper'

class AccountTest < Test::Unit::TestCase

  context 'an Account instance' do
    setup do
      start_transaction
      @account = Account.gen
    end

    def teardown
      rollback_transaction
    end

    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
    #should validate_presence_of(:client)
    should have_many(:users)
    should have_many(:domains)

  end
end
