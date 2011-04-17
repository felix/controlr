require 'test_helper'

class DefaultNameRecordTest < Test::Unit::TestCase

  context 'a DefaultNameRecord instance' do
    setup do
      start_transaction
      @record = DefaultNameRecord.gen
    end

    def teardown
      rollback_transaction
    end

    should "be valid" do
      assert @record.valid?
    end

    should_not validate_presence_of(:host)
    should validate_presence_of(:type)
    should validate_presence_of(:value)
    should belong_to(:account)
    should allow_value(nil).for(:ttl)

    should 'default to type A' do
      assert @record.type == 'A'
    end

    should 'not set ttl if nil' do
      nr = DefaultNameRecord.gen(:ttl => '')
      assert nr.ttl.nil?
    end

    should "not set ttl below config minimum ttl" do
      @record.update(:ttl => CONFIG['dns_min_ttl']-10)
      assert @record.ttl == CONFIG['dns_min_ttl']
    end

    context 'when A record' do
      setup do
        @record.type = 'A'
      end
      should allow_value('192.168.1.1').for(:value)
      should_not allow_value('example.com').for(:value)
    end

    context 'when MX record' do
      setup do
        @record.type = 'MX'
      end
      should_not allow_value('192.168.1.1').for(:value)
      should allow_value('example.com').for(:value)
    end

  end
end

