require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'Users Controller' do
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
      Client.auto_migrate!
      Account.auto_migrate!
      User.auto_migrate!
      @client = Client.gen
      @account = Account.gen(:client => @client)
      @user = User.gen(:account => @account)
    end

    teardown do
      repository(:default).adapter.pop_transaction.rollback
    end

    context 'on GET to :index' do

      should 'require login' do
        get :index
        assert_redirected_to new_user_session_path
      end

      context 'with login' do

        setup do
          sign_in @user
        end

        should 'allow a logged in user' do
          get :index
          assert_response :success
          assert_not_nil assigns(:users)
        end

        should 'get index' do
          get :index
          assert_response :success
          assert_not_nil assigns(:users)
        end
      end
    end

    context 'on GET to :new' do
      should "should get new" do
        get :new
        assert_response :success
      end
    end

    context 'on POST to :new' do
      should 'create user' do
        assert_difference('User.count') do
          post :create, :user => User.gen(:account => @account).attributes
        end

        assert_response :success
        assert_not_nil assigns(:user)
      end
    end

    context 'on GET to :show' do
      should 'require login' do
        get :show, :id => @user.to_param
        assert_redirected_to new_user_session_path
      end

      context 'with login' do
        setup do
          sign_in @user
        end

        should 'show user' do
          get :show, :id => @user.to_param
          assert_response :success
        end
      end
    end

    context 'on GET to :edit' do
      should 'require a login' do
        get :edit, :id => @user.to_param
        assert_redirected_to new_user_session_path
      end

      context 'with login' do

        setup do
          sign_in @user
        end

        should 'get edit' do
          get :edit, :id => @user.to_param
          assert_response :success
          assert_not_nil assigns(:user)
        end
      end
    end

    context 'on PUT to :update' do
      should 'require a login' do
        put :update, :id => @user.to_param, :user => @user.attributes
        assert_redirected_to new_user_session_path
      end

      context 'with login' do
        setup do
          sign_in @user
        end

        should 'update user' do
          put :update, :id => @user.to_param, :user => @user.attributes
          assert_redirected_to user_path(assigns(:user))
        end
      end
    end

    context 'on DELETE to :destroy' do
      should 'require a login' do
        delete :destroy, :id => @user.to_param
        assert_redirected_to new_user_session_path
      end

      context 'with login' do
        setup do
          sign_in @user
        end

        should 'destroy user' do
          assert_difference('User.count', -1) do
            delete :destroy, :id => @user.to_param
          end
          assert_redirected_to users_path
        end
      end
    end

  end
end
