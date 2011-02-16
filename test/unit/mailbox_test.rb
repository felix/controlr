require 'test_helper'

class MailboxTest < Test::Unit::TestCase
  context 'a Mailbox instance' do

    setup do
      @mailbox = Mailbox.gen
    end

    should 'require an email' do
      @mailbox.email = nil
      assert !@mailbox.valid?
    end

    should 'require a valid email' do
      @mailbox.email = 'test@example.com'
      assert @mailbox.valid?
      assert !@mailbox.errors[:email].nil?
      @mailbox.email = '@example.com'
      assert !@mailbox.valid?
      assert !@mailbox.errors[:email].nil?
      @mailbox.email = 'test.example.com'
      assert !@mailbox.valid?
      assert !@mailbox.errors[:email].nil?
    end

  end
end
