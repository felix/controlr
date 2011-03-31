require 'test_helper'

class MailboxTest < Test::Unit::TestCase

  context 'a Mailbox instance' do
    setup do
      start_transaction
      @mailbox = Mailbox.gen
    end

    def teardown
      rollback_transaction
    end

    should 'be valid' do
      assert @mailbox.valid?
    end

    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
    should validate_presence_of(:passhash)
    should belong_to(:domain)
    #should_not allow_value('test').for(:email)
    #should_not allow_value('test@').for(:email)
    #should_not allow_value('@example.com').for(:email)

    should 'create an alias also' do
      mb = Mailbox.gen(:domain => @mailbox.domain, :email => 'test123@bob.com')
      a = @mailbox.domain.aliases.first(:source => mb.email)
      assert_not_nil a
    end

    should 'convert passhash to MD5 hash' do
      @mailbox.passhash = 'test'
      assert @mailbox.passhash = '098f6bcd4621d373cade4e832627b4f6'
    end

    should 'have default quota equal to domains' do
      mb = Mailbox.gen(:quota => nil)
      assert mb.quota == mb.domain.email_default_quota
      mb.update(:quota => nil)
      assert mb.quota == mb.domain.email_default_quota
    end

    should allow_value('').for(:quota)
    should allow_value('1').for(:quota)
    should allow_value('1b').for(:quota)
    should allow_value('1k').for(:quota)
    should_not allow_value('100Mb').for(:quota)
    should_not allow_value('100T').for(:quota)
    should_not allow_value('100%').for(:quota)

  end
end
