require 'test_helper'

class EmailTest < Test::Unit::TestCase

  context 'an Email instance' do
    setup do
      @email = Email.gen
    end

    should 'be valid' do
      assert @email.valid?
    end

    should validate_presence_of(:address)

    should 'return an array for destinations' do
      assert @email.destinations.class == Array
      @email.store = true
      assert @email.destinations.class == Array
      @email.destination = ''
      assert @email.destinations.class == Array
    end

    should 'enable storing' do
      @email.store = true
      assert @email.destination = @email.address
      assert @email.store
    end

    should 'enable not storing' do
      @email.store = false
      assert !@email.destination.include?(@email.address)
    end

    should 'store destination as a string' do
      assert @email.destination.class == String
    end

    should 'remove duplicates from destinations' do
      @email.destination = ['test1@example.com','test1@example.com']
      assert @email.destinations.size == 1
    end

    should 'allow nil to be passed to destination' do
      @email.destination = nil
      assert @email.destination == ''
      assert @email.destinations == []
    end

    should 'allow empty string to be passed to destination' do
      @email.destination = ''
      assert @email.destination == ''
      assert @email.destinations == []
    end

  end
end
