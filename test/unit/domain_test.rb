require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context 'a Domain instance' do
    setup do
      start_transaction
      @domain = Domain.gen
    end

    def teardown
      rollback_transaction
    end

    should "be valid" do
      assert @domain.valid?
    end
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name)
    should belong_to(:account)
    should have_many(:mailboxes)
    should have_many(:aliases)
    should allow_value('example.com').for(:name)
    should allow_value('3example.com').for(:name)
    should_not allow_value('@example.com').for(:name)
    should_not allow_value('test@example.com').for(:name)
    should_not allow_value('test').for(:name)

  end
end
