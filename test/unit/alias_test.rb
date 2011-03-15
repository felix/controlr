require 'test_helper'

class AliasTest < Test::Unit::TestCase

  context 'an Alias instance' do
    Domain.auto_migrate!
    Alias.auto_migrate!
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      @domain = Domain.gen
      @alias = Alias.gen(:domain => @domain)
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    should 'be valid' do
      assert @alias.valid?
    end

    should validate_presence_of(:source)

    should 'store destination as a string' do
      assert @alias.destination.class == String
    end

    should 'remove duplicates from destination' do
      @alias.destination = ['test1@example.com','test1@example.com']
      assert @alias.destination == 'test1@example.com'
    end

    should 'allow nil to be passed to destination' do
      @alias.destination = nil
      assert @alias.destination == ''
    end

    should 'allow empty string to be passed to destination' do
      @alias.destination = ''
      assert @alias.destination == ''
    end

  end
end
