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

    should 'convert password to MD5 hash' do
      @domain.passhash = 'test'
      assert @domain.passhash = '098f6bcd4621d373cade4e832627b4f6'
    end

    should 'have default value for email_default_quota' do
      assert !@domain.email_default_quota.nil?
    end

    should allow_value('1').for(:email_default_quota)
    should allow_value('1b').for(:email_default_quota)
    should allow_value('1k').for(:email_default_quota)
    should_not allow_value('100Kb').for(:email_default_quota)
    should_not allow_value('100T').for(:email_default_quota)
    should_not allow_value('100%').for(:email_default_quota)

  end
end
