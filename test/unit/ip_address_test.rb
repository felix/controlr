require 'test_helper'

describe IpAddress do

  it 'must require an address' do
    a = IpAddress.gen(:address => nil)
    assert !a.valid?
    refute_nil a.errors[:address]
  end

end
