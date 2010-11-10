require 'test_helper'

class ClienTest < Test::Unit::TestCase

  context 'a Client instance' do

    setup do
      @client = Client.gen
    end

    should 'require a name' do
      @client.name = nil
      assert !@client.valid?
      assert !@client.errors[:name].nil?
      @client.name = /\w+/.gen
      assert @client.valid?
      assert @client.errors[:name].empty?
    end

    should 'have a unique name' do
      d = Client.gen(:name => @client.name)
      assert !d.valid?
      assert !d.errors[:name].nil?
      d.name = 'foo123'
      assert d.valid?
      assert d.errors[:name].empty?
    end

  end
end
