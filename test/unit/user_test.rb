require 'test_helper'

describe User do
  it 'requires an email' do
    u = User.gen(:email => nil)
    assert !u.valid?
    refute_nil u.errors[:email]
  end
end
