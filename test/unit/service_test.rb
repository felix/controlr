require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  test 'requires a name' do
    s = Service.gen(:name => nil)
    assert !s.valid?
    assert_not_nil s.errors[:name]
  end

end
