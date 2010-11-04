require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  setup do
    @valid_attributes = {
      :name => 'service',
      :active => true
    }
    @service = Service.create(@valid_attributes)
    @service1 = Service.new(@valid_attributes.merge(:name => 'service1'))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, :service => @service1.attributes
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, :id => @service.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @service.to_param
    assert_response :success
  end

  test "should update service" do
    put :update, :id => @service.to_param, :service => @service.attributes
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, :id => @service.to_param
    end

    assert_redirected_to services_path
  end
end
