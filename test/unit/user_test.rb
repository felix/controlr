require 'test_helper'

class UserTest < Test::Unit::TestCase

  context 'an User instance' do
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      @user = User.gen
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    should 'be valid' do
      assert @user.valid?
    end

    should validate_presence_of(:email)
    should belong_to(:account)
    should allow_value('felix@home.org').for(:email)
    should_not allow_value('felix').for(:email)
    should_not allow_value('@home').for(:email)

    should 'be able to clear roles' do
      @user.role_ids = []
      @user.save
      assert @user.roles == []
    end

    should 'be able to change roles' do
      @user.roles.clear
      @user.roles << Role.first
      @user.save
      assert @user.roles.count == 1
    end
  end
end
