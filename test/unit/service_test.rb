require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  test 'requires a name' do
    s = Service.new
    assert !s.valid?
    assert_not_nil s.errors[:name]
  end

end
