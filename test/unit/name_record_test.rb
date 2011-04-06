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

    should 'default to type A' do
      assert @record.type == 'A'
    end

    should 'have default ttl created if nil' do
      nr = NameRecord.gen(:ttl => nil)
      assert nr.ttl == nr.domain.dns_min_ttl
    end

    should 'have default ttl if update as nil' do
      @record.update(:ttl => nil)
      assert @record.ttl == @record.domain.dns_min_ttl
    end

    should 'have default ttl created as 0' do
      nr = NameRecord.gen(:ttl => 0)
      assert nr.ttl == nr.domain.dns_min_ttl
    end

    should 'have default ttl if update as 0' do
      @record.update(:ttl => 0)
      assert @record.ttl == @record.domain.dns_min_ttl
    end

    should "not set ttl above domain's default ttl" do
      @record.update(:ttl => @record.domain.dns_min_ttl-10)
      assert @record.ttl == @record.domain.dns_min_ttl
    end

    should 'suffix the domain name if just local part' do
      @record.update(:host => 'blah')
      assert @record.host == "blah.#{@record.domain.name}"
    end

    should 'leave the domain suffix unchanged if already present' do
      @record.update(:host => "blah.#{@record.domain.name}")
      assert @record.host == "blah.#{@record.domain.name}"
    end

  end
end
