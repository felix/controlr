require 'test_helper'

class ServerTest < ActiveSupport::TestCase

  def setup
    @server = Server.gen
  end

  test 'requires a name' do
    s = Server.new
    assert !s.valid?
    assert_not_nil s.errors[:name]
  end

end
