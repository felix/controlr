require 'test_helper'

class AliasTest < Test::Unit::TestCase

  context 'an Alias instance' do
    setup do
      start_transaction
      @domain = Domain.gen
      @alias = Alias.gen(:domain => @domain)
    end

    def teardown
      rollback_transaction
    end

    should 'be valid' do
      assert @alias.valid?
    end

    should validate_presence_of(:source)
    should belong_to(:domain)

    should 'default to non-system' do
      assert @alias.system == false
    end

    should 'store destination as a string' do
      assert @alias.destination.class == String
    end

    should 'store destinations as comma separated string' do
      @alias.destination = ['test1@example.com','test2@example.com']
      assert @alias.destination == 'test1@example.com,test2@example.com'
    end

    should 'remove duplicates from destination' do
      @alias.destination = ['test1@example.com','test1@example.com']
      assert @alias.destination == 'test1@example.com'
    end

    should 'not contain any whitespace in destination' do
      @alias.destination = "one\ntwo three   four"
      assert @alias.destination == 'one,two,three,four'
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
