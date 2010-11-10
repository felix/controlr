require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  describe ClientsController do
    before do
      Client.auto_migrate!
      @client = Client.gen
    end

    it "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:clients)
    end

    it "should get new" do
      get :new
      assert_response :success
    end

    it "should create client" do
      assert_difference('Client.count') do
        post :create, :client => Client.make.attributes
      end

      assert_redirected_to client_path(assigns(:client))
    end

    it "should show client" do
      get :show, :id => @client.to_param
      assert_response :success
    end

    it "should get edit" do
      get :edit, :id => @client.to_param
      assert_response :success
    end

    it "should update client" do
      put :update, :id => @client.to_param, :client => @client.attributes
      assert_redirected_to client_path(assigns(:client))
    end

    it "should not destroy client with accounts" do
      Account.gen(:client => @client)
      assert_no_difference('Client.count') do
        delete :destroy, :id => @client.to_param
      end

      assert_redirected_to clients_path
    end

    it 'should destroy client with no accounts' do
      assert_difference('Client.count', -1) do
        delete :destroy, :id => @client.to_param
      end
      assert_redirected_to clients_path
    end
  end
end
