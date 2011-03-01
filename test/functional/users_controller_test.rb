require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'Users Controller' do
    setup do
      Client.auto_migrate!
      Account.auto_migrate!
      User.auto_migrate!
      @client = Client.gen
      @account = Account.gen(:client => @client)
      @user = User.gen(:account => @account)
    end

    context 'while authed' do
      setup do
        sign_in @user
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:users)
      end

      context 'on POST to :new' do

        context 'with valid data' do
          setup do
            post :create, :user => User.gen(:account => @account).attributes
          end

          should respond_with(:success)
          should assign_to(:user)
        end

        context 'with invalid data' do
          setup do
            post :create, :user => User.gen(:account => nil).attributes
          end

          should respond_with(:success)
          should render_with_layout
          should render_template(:new)
        end
      end

      context 'on GET to :show' do
        should 'show user' do
          get :show, :id => @user.id
          assert_response :success
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @user.id
          assert_response :success
          assert_not_nil assigns(:user)
        end
      end

      context 'on PUT to :update' do
        should 'update user' do
          put :update, :id => @user.id, :user => @user.attributes
          assert_redirected_to user_path(assigns(:user))
        end
      end

      context 'on DELETE to :destroy' do
        should 'destroy user' do
          assert_difference('User.count', -1) do
            delete :destroy, :id => @user.id
          end
          assert_redirected_to users_path
        end
      end

    end

    context 'while unauthed' do

      context 'on GET to :index' do
        should 'require login' do
          get :index
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :new' do
        should "should get new" do
          get :new
          assert_response :success
        end
      end

      context 'on GET to :show' do
        should 'require login' do
          get :show, :id => @user.id
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :edit' do
        should 'require a login' do
          get :edit, :id => @user.id
          assert_redirected_to new_user_session_path
        end
      end

      context 'on PUT to :update' do
        should 'require a login' do
          put :update, :id => @user.id, :user => @user.attributes
          assert_redirected_to new_user_session_path
        end
      end

      context 'on DELETE to :destroy' do
        should 'require a login' do
          delete :destroy, :id => @user.id
          assert_redirected_to new_user_session_path
        end
      end
    end
  end
end
