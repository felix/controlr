require 'test_helper'

describe Server do

  it 'must require a name' do
    s = Server.gen(:name => nil)
    assert !s.valid?
    refute_nil s.errors[:name]
  end

end
