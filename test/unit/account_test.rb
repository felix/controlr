require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @client = Client.gen
  end

  test 'requires a name' do
    a = Account.gen(:name => nil, :client => @client)
    assert !a.valid?
    assert_not_nil a.errors[:name]
    a.name = /\w+/.gen
    assert a.valid?
    assert a.errors[:name].empty?
  end

  test 'requires a client' do
    a = Account.gen(:client => nil)
    assert !a.valid?
    assert_not_nil a.errors[:client]
    a.client = @client
    assert a.valid?
    assert a.errors[:client].empty?
  end

  test 'does not require a user' do
    a = Account.gen(:client => @client)
    assert a.valid?
    a.users = []
    assert a.valid?
  end

end
