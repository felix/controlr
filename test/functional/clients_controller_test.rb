require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    Client.auto_migrate!
    @client = Client.gen(:accounts)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, :client => Client.make.attributes
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, :id => @client.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @client.to_param
    assert_response :success
  end

  test "should update client" do
    put :update, :id => @client.to_param, :client => @client.attributes
    assert_redirected_to client_path(assigns(:client))
  end

  test "should not destroy client with accounts" do
    assert_no_difference('Client.count') do
      delete :destroy, :id => @client.to_param
    end

    assert_redirected_to clients_path
  end

  test 'should destroy client with no accounts' do
    client = Client.create(Client.make.attributes.merge(:id => nil))
    assert client.valid?
    assert_difference('Client.count', -1) do
      delete :destroy, :id => client.to_param
    end
    assert_redirected_to clients_path
  end
end
