require 'test_helper'

class UserTest < Test::Unit::TestCase

  context 'an User instance' do

    setup do
      @user = User.gen
    end

    should 'require an email' do
      @user.email = nil
      assert !@user.valid?
      assert !@user.errors[:email].nil?
    end

  end
end
