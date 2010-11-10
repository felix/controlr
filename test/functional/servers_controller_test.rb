require 'test_helper'

describe ServersController do
  before do
    Server.auto_migrate!
    @server = Server.gen
  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  it "should create server" do
    assert_difference('Server.count') do
      post :create, :server => Server.make.attributes
    end

    assert_redirected_to server_path(assigns(:server))
  end

  it "should show server" do
    get :show, :id => @server.to_param
    assert_response :success
  end

  it "should get edit" do
    get :edit, :id => @server.to_param
    assert_response :success
  end

  it "should update server" do
    put :update, :id => @server.to_param, :server => @server.attributes
    assert_redirected_to server_path(assigns(:server))
  end

  it "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, :id => @server.to_param
    end

    assert_redirected_to servers_path
  end
end
