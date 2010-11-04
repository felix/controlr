require 'test_helper'

class IpAddressesControllerTest < ActionController::TestCase
  setup do
    @ip_address = IpAddress.gen
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ip_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ip_address" do
    assert_difference('IpAddress.count') do
      post :create, :ip_address => IpAddress.gen(:address => '10.7.6.5').attributes
    end

    assert_response :success
    #assert_redirected_to ip_address_path(assigns(:ip_address))
  end

  test "should show ip_address" do
    get :show, :id => @ip_address.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ip_address.to_param
    assert_response :success
  end

  test "should update ip_address" do
    put :update, :id => @ip_address.to_param, :ip_address => @ip_address.attributes
    assert_redirected_to ip_address_path(assigns(:ip_address))
  end

  test "should destroy ip_address" do
    assert_difference('IpAddress.count', -1) do
      delete :destroy, :id => @ip_address.to_param
    end

    assert_redirected_to ip_addresses_path
  end
end
