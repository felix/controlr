require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'requires an email' do
    u = User.gen(:email => nil)
    assert !u.valid?
    assert_not_nil u.errors[:email]
  end
end
