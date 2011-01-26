require 'test_helper'

class EmailTest < Test::Unit::TestCase

  context 'an Email instance' do

    setup do
      @email = Email.gen
    end

    should 'require an address' do
      @email.address = nil
      assert !@email.valid?
      assert !@email.errors[:address].nil?
    end

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

  end
end
