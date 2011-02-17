require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  should "be valid" do
    assert Role.new.valid?
  end
end
