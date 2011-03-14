require 'test_helper'

class UserTest < Test::Unit::TestCase

  context 'an User instance' do
    setup do
      #@user = User.gen
      @user = valid_user
    end

    should 'be valid' do
      assert @user.valid?
    end

    should validate_presence_of(:email)
    should allow_value('felix@home.org').for(:email)
    should_not allow_value('felix').for(:email)
    should_not allow_value('@home').for(:email)
  end
end
