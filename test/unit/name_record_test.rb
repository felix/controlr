require 'test_helper'

class NameRecordTest < Test::Unit::TestCase

  context 'a NameRecord instance' do
    setup do
      start_transaction
      @record = NameRecord.gen
    end

    def teardown
      rollback_transaction
    end

    should "be valid" do
      assert @record.valid?
    end

    should validate_presence_of(:host)
    should validate_presence_of(:type)
    should belong_to(:domain)

    should 'default to type A' do
      assert @record.type == 'A'
    end

  end
end
