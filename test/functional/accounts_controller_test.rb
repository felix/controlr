require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @client = Client.gen
    @account = Account.gen(
      :client => @client,
      :users => 2.of {User.gen}
    )
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, :account => Account.make(:client => @client).attributes
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should show account" do
    get :show, :id => @account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @account.to_param
    assert_response :success
  end

  test "should update account" do
    put :update, :id => @account.to_param, :account => @account.attributes
    assert_redirected_to account_path(assigns(:account))
  end

  test 'should not destroy an account with users' do
    assert_no_difference('Account.count') do
      delete :destroy, :id => @account.to_param
    end
    assert_redirected_to accounts_path
  end

  test "should destroy an account with no users" do
    acc = Account.create(@account.attributes.merge(:id => nil))
    assert_difference('Account.count', -1) do
      delete :destroy, :id => acc.to_param
    end

    assert_redirected_to accounts_path
  end
end
