require 'test_helper'

describe Service do

  it 'requires a name' do
    s = Service.gen(:postfix, :name => nil)
    assert !s.valid?
    refute_nil s.errors[:name]
    s.name = 'Postfix'
    assert s.valid?
    assert_empty s.errors[:name]
  end

  it 'requires a start command' do
    s = Service.gen(:postfix, :start_cmd => nil)
    assert !s.valid?
    refute_nil s.errors[:start_cmd]
    s.start_cmd = '/etc/init.d/postfix start'
    assert s.valid?
    assert_empty s.errors[:start_cmd]
  end

  it 'requires a stop command' do
    s = Service.gen(:postfix, :stop_cmd => nil)
    assert !s.valid?
    refute_nil s.errors[:stop_cmd]
    s.stop_cmd = '/etc/init.d/postfix stop'
    assert s.valid?
    assert_empty s.errors[:stop_cmd]
  end

  it 'requires a server' do
    s = Service.gen(:postfix, :server => nil)
    assert !s.valid?
    refute_nil s.errors[:server]
    s.server = Server.make
    assert s.valid?
    assert_empty s.errors[:server]
  end

end
