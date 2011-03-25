require 'test_helper'

class MailboxTest < Test::Unit::TestCase

  context 'an Mailbox instance' do
    setup do
      start_transaction
      @domain = Domain.gen
      @mailbox = @domain.mailboxes.gen
    end

    def teardown
      rollback_transaction
    end

    should 'be valid' do
      assert @mailbox.valid?
    end

    should validate_presence_of(:email)
    should validate_presence_of(:passhash)
    should belong_to(:domain)
    #should_not allow_value('test').for(:email)
    #should_not allow_value('test@').for(:email)
    #should_not allow_value('@example.com').for(:email)

    should 'create an alias also' do
      mb = Mailbox.gen(:domain => @domain, :email => 'test123@bob.com')
      a = @domain.aliases.first(:source => mb.email)
      assert_not_nil a
    end

    should 'convert password to MD5 hash' do
      @mailbox.passhash = 'test'
      assert @mailbox.passhash = '098f6bcd4621d373cade4e832627b4f6'
    end

  end
end
