require 'test_helper'

class RoleTest < Test::Unit::TestCase
  context 'a Role instance' do
    setup do
      start_transaction
      @role = Role.gen
    end

    def teardown
      rollback_transaction
    end

    should "be valid" do
      assert @role.valid?
    end

    should validate_presence_of(:name)

    should 'return permissions as Array' do
      assert @role.permissions.class == Array
    end

    should 'return permissions as Array even when empty' do
      @role.permissions = nil
      assert @role.permissions.class == Array
    end
  end
end
