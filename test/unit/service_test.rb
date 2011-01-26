require 'test_helper'

class ServiceTest < Test::Unit::TestCase

  context 'a Service instance' do

    setup do
      @postfix = Service.gen(:postfix)
    end

    should 'be valid' do
      assert @postfix.valid?
    end

    should 'require a name' do
      @postfix.name = nil
      assert !@postfix.valid?
      assert !@postfix.errors[:name].nil?
      @postfix.name = 'Postfix'
      assert @postfix.valid?
      assert @postfix.errors[:name].empty?
    end

    should 'require a start command' do
      @postfix.start_cmd = nil
      assert !@postfix.valid?
      assert !@postfix.errors[:start_cmd].nil?
      @postfix.start_cmd = '/etc/init.d/postfix start'
      assert @postfix.valid?
      assert @postfix.errors[:start_cmd].empty?
    end

    should 'require a stop command' do
      @postfix.stop_cmd = nil
      assert !@postfix.valid?
      assert !@postfix.errors[:stop_cmd].nil?
      @postfix.stop_cmd = '/etc/init.d/postfix stop'
      assert @postfix.valid?
      assert @postfix.errors[:stop_cmd].empty?
    end

    should 'require a server' do
      @postfix.server = nil
      assert !@postfix.valid?
      assert !@postfix.errors[:server].nil?
      @postfix.server = Server.make
      assert @postfix.valid?
      assert @postfix.errors[:server].empty?
    end

  end
end
