require 'test_helper'

class RoleTest < Test::Unit::TestCase
  context 'a Role instance' do

    setup do
      @role = Role.gen
    end

    should "be valid" do
      assert @role.valid?
    end
  end
end
