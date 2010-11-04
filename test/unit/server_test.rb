require 'test_helper'

class ServerTest < ActiveSupport::TestCase

  test 'requires a name' do
    s = Server.gen(:name => nil)
    assert !s.valid?
    assert_not_nil s.errors[:name]
  end

end
