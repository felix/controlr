require 'test_helper'

class IpAddressTest < Test::Unit::TestCase

  context 'an IpAddress instance' do

    setup do
      @address = IpAddress.gen
    end

    should 'require an address' do
      @address.address = nil
      assert !@address.valid?
      assert !@address.errors[:address].empty?
    end

    should 'have a unique public address' do
      b = IpAddress.gen(:address => @address.address)
      assert !b.valid?
      assert !b.errors[:address].empty?
    end

    should 'can have duplicate private addresses' do
      a = IpAddress.gen(:private)
      b = IpAddress.gen(
        :address => a.address
      )
      assert b.valid?
      assert b.errors[:address].empty?
    end

  end
end
