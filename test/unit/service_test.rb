require 'test_helper'

class ServiceTest < Test::Unit::TestCase

  context 'a Service instance' do

    setup do
      @service = Service.gen(:postfix)
    end

    should 'be valid' do
      assert @service.valid?
    end

    should 'require a name' do
      @service.name = nil
      assert !@service.valid?
      assert !@service.errors[:name].nil?
      @service.name = 'Postfix'
      assert @service.valid?
      assert @service.errors[:name].empty?
    end

    should 'require a start command' do
      @service.start_cmd = nil
      assert !@service.valid?
      assert !@service.errors[:start_cmd].nil?
      @service.start_cmd = '/etc/init.d/postfix start'
      assert @service.valid?
      assert @service.errors[:start_cmd].empty?
    end

    should 'require a stop command' do
      @service.stop_cmd = nil
      assert !@service.valid?
      assert !@service.errors[:stop_cmd].nil?
      @service.stop_cmd = '/etc/init.d/postfix stop'
      assert @service.valid?
      assert @service.errors[:stop_cmd].empty?
    end

    should 'require a server' do
      @service.server = nil
      assert !@service.valid?
      assert !@service.errors[:server].nil?
      @service.server = Server.make
      assert @service.valid?
      assert @service.errors[:server].empty?
    end

  end
end
