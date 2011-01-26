require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context 'a Domain instance' do

    setup do
      @domain = Domain.gen
    end

    should "be valid" do
      assert @domain.valid?
    end

  end
end
