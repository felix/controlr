require 'test_helper'

describe Client do

  it 'must require a name' do
    c = Client.gen(:name => nil)
    assert !c.valid?
    refute_nil c.errors[:name]
    c.name = /\w+/.gen
    assert c.valid?
    assert_empty c.errors[:name]
  end

  it 'must have a unique name' do
    c = Client.gen
    d = Client.gen(:name => c.name)
    assert !d.valid?
    refute_nil d.errors[:name]
    d.name = 'foo123'
    assert d.valid?
    assert_empty d.errors[:name]
  end

end
