require 'test_helper'

class AccountTest < Test::Unit::TestCase
=begin

  context 'an Account instance' do

    setup do
      @account = Account.gen
    end

    should 'require a name' do
      @account.name = nil
      assert !@account.valid?
      assert !@account.errors[:name].nil?
      @account.name = /\w+/.gen
      assert @account.valid?
      assert @account.errors[:name].empty?
    end

    should 'must require a client' do
      @account.client = nil
      assert !@account.valid?
      assert !@account.errors[:client].nil?
      @account.client = Client.gen
      assert @account.valid?
      assert @account.errors[:client].empty?
    end

    should 'must not require a user' do
      assert @account.valid?
      @account.users = []
      assert @account.valid?
    end

  end
=end
end
