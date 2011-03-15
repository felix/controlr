require 'test_helper'

class MailboxTest < Test::Unit::TestCase

  context 'an Mailbox instance' do
    Domain.auto_migrate!
    Mailbox.auto_migrate!
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      @mailbox = Mailbox.gen
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    should 'be valid' do
      assert @mailbox.valid?
    end

    should validate_presence_of(:email)
    should validate_presence_of(:domain)
    should_not allow_value('test').for(:email)
    should_not allow_value('test@').for(:email)
    should_not allow_value('@example.com').for(:email)
  end
end
