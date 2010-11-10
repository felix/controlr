require 'test_helper'

describe Account do

  it 'must require a name' do
    a = Account.gen(:name => nil)
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
    a.client = Client.gen
    assert a.valid?
    assert_empty a.errors[:client]
  end

  it 'must not require a user' do
    a = Account.gen
    assert a.valid?
    a.users = []
    assert a.valid?
  end

end
