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

    should 'have default value for email_max_quota' do
      assert !@domain.email_max_quota.nil?
    end

    should allow_value('1').for(:email_max_quota)
    should_not allow_value('100Kb').for(:email_max_quota)
    should_not allow_value('100%').for(:email_max_quota)

    should 'generate tinydns config file' do
      @domain.dns_active = true
      NameRecord.gen(:domain => @domain)
      assert_not_nil @domain.sync_config_files
      assert File.exists?(File.join(CONFIG['config_file_base'],'tinydns',@domain.name))
    end

    should 'clear tinydns config file if dns is inactive' do
      @domain.dns_active = false
      NameRecord.gen(:domain => @domain)
      assert_nil @domain.sync_config_files
      assert !File.exists?(File.join(CONFIG['config_file_base'],'tinydns',@domain.name))
    end
  end
end
