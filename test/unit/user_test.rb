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

    should 'require a first name' do
      @user.firstname = nil
      assert !@user.valid?
      assert !@user.errors[:firstname].nil?
    end

    should 'belong to an account' do
      @user.account = nil
      assert !@user.valid?
      assert !@user.errors[:account].nil?
    end

    if defined? Shoulda::DataMapper
      should allow_value('felix@home.org').for(:email)
      should_not allow_value('felix').for(:email)
      should_not allow_value('@home').for(:email)
    end
  end
end
