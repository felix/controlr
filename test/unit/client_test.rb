require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test 'requires a name' do
    c = Client.gen(:name => nil)
    assert !c.valid?
    assert_not_nil c.errors[:name]
    c.name = /\w+/.gen
    assert c.valid?
    assert c.errors[:name].empty?
  end
end
