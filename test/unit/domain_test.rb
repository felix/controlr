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

    should 'downcase name' do
      @domain.name = 'UPPERCASE'
      assert @domain.name == 'uppercase'
    end

    should 'generate tinydns config file' do
      @domain.dns_active = true
      @domain.sync_config_files
      assert File.exists?(File.join(CONFIG['config_file_base'],'tinydns',@domain.name))
    end

    should 'have one entry in config file for each active record' do
      @domain.dns_active = true
      @domain.sync_config_files
      filename = File.join(CONFIG['config_file_base'],'tinydns',@domain.name)
      count = %x{wc -l #{filename}}.split.first.to_i
      assert @domain.name_records.count(:active => true) == count
    end

    should 'clear tinydns config file if dns is inactive' do
      @domain.dns_active = false
      @domain.sync_config_files
      assert !File.exists?(File.join(CONFIG['config_file_base'],'tinydns',@domain.name))
    end

    should 'have default aliases created from account' do
      assert @domain.aliases.count > 0
      assert @domain.aliases.count == @domain.account.default_aliases.count
    end

    should 'have default name records created from account' do
      assert @domain.name_records.count > 0
      assert @domain.name_records.count == @domain.account.default_name_records.count
    end

    should 'require MX records if email is active' do
      @domain.email_active = true
      # assuming all MX records are inactive
      assert !@domain.valid?
    end

    should 'be valid with at least one MX record and email active' do
      @domain.email_active = true
      # assuming all MX records are inactive
      mx = @domain.name_records.first(:type => 'MX')
      mx.active = true
      assert @domain.valid?
    end
  end
end
