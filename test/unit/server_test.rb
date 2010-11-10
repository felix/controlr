require 'test_helper'

class ServerTest < Test::Unit::TestCase

  context 'a Server instance' do

    setup do
      @server = Server.gen
    end

    should 'be valid' do
      assert @server.valid?
    end

    should 'require a name' do
      @server.name = nil
      assert !@server.valid?
      assert !@server.errors[:name].empty?
    end

  end

end
