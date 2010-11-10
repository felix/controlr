require 'test_helper'

describe Account do
  def setup
    @client = Client.gen
  end

  it 'must require a name' do
    a = Account.gen(:name => nil, :client => @client)
    assert !a.valid?
    refute_nil a.errors[:name]
    a.name = /\w+/.gen
    assert a.valid?
    assert_empty a.errors[:name]
  end

  it 'must require a client' do
    a = Account.gen(:client => nil)
    assert !a.valid?
    refute_nil a.errors[:client]
    a.client = @client
    assert a.valid?
    assert_empty a.errors[:client]
  end

  it 'must not require a user' do
    a = Account.gen(:client => @client)
    assert a.valid?
    a.users = []
    assert a.valid?
  end

end
