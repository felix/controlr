require 'test_helper'

class AbilityTest < Test::Unit::TestCase

  context 'a Ability instance' do
    setup do
      start_transaction
      @user = User.gen
      @ability = Ability.new(@user)
    end

    def teardown
      rollback_transaction
    end

    should 'be able to read self' do
      assert @ability.can?(:read, User, @user)
    end

    should 'be able to edit self' do
      assert @ability.can?(:edit, User, @user)
    end

  end
end
