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
    should validate_presence_of(:value)
    should belong_to(:domain)
    should allow_value(nil).for(:ttl)

    should 'default to type A' do
      assert @record.type == 'A'
    end

    should 'not set ttl if nil' do
      nr = NameRecord.gen(:ttl => '')
      assert nr.ttl.nil?
    end

    should "not set ttl below config minimum ttl" do
      @record.update(:ttl => CONFIG['dns_min_ttl']-10)
      assert @record.ttl == CONFIG['dns_min_ttl']
    end

    should 'suffix the domain name if just local part' do
      @record.update(:host => 'blah')
      assert @record.host == "blah.#{@record.domain.name}"
    end

    should 'leave the domain suffix unchanged if already present' do
      @record.update(:host => "blah.#{@record.domain.name}")
      assert @record.host == "blah.#{@record.domain.name}"
    end

    context 'when A record' do
      setup do
        @record.type = 'A'
      end
      should allow_value('192.168.1.1').for(:value)
      should_not allow_value('example.com').for(:value)
    end

    context 'when CNAME record' do
      setup do
        @record.type = 'CNAME'
      end
      should_not allow_value('192.168.1.1').for(:value)
      should allow_value('example.com').for(:value)
    end

  end
end
