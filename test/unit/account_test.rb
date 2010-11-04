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
end
