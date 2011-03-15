require 'test_helper'

class DomainTest < Test::Unit::TestCase

  context 'a Domain instance' do
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      @domain = Domain.gen
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    should "be valid" do
      assert @domain.valid?
    end
    should validate_presence_of(:name)

    should 'create default aliases' do
      assert @domain.aliases != nil
    end
  end
end
