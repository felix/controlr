require 'test_helper'

class IpAddressTest < ActiveSupport::TestCase

  test 'requires an address' do
    a = IpAddress.gen(:address => nil)
    assert !a.valid?
    assert_not_nil a.errors[:address]
  end

end
