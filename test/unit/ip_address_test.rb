require 'test_helper'

describe IpAddress do
  before do
    IpAddress.auto_migrate!
  end

  it 'must require an address' do
    a = IpAddress.gen(:address => nil)
    assert !a.valid?
    refute_nil a.errors[:address]
  end

  it 'must have a unique public address' do
    a = IpAddress.gen(:private => false)
    b = IpAddress.gen(:private => false, :address => a.address)
    assert !b.valid?
    refute_nil b.errors[:address]
  end

end
