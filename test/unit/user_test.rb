require 'test_helper'

class UserTest < Test::Unit::TestCase

  context 'an User instance' do
    setup do
      start_transaction
      @user = User.gen
    end

    def teardown
      rollback_transaction
    end

    should 'be valid' do
      assert @user.valid?
    end

    should validate_presence_of(:email)
    should belong_to(:account)
    should allow_value('felix@home.org').for(:email)
    should_not allow_value('felix').for(:email)
    should_not allow_value('@home').for(:email)
    should validate_presence_of(:role)

  end
end
