require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'Users Controller' do
    setup do
      repository(:default) do
        transaction = DataMapper::Transaction.new(repository)
        transaction.begin
        repository.adapter.push_transaction(transaction)
      end
    end

    def teardown
      repository(:default).adapter.pop_transaction.rollback
    end

    context 'while authed' do
      setup do
        User.auto_migrate!
        @user = User.gen
        @user.roles << Role.first(:name => 'admin')
        @user.save
        raise "INVALID #{@user.errors.inspect}" unless @user.valid?
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
            post :create, :user => User.gen.attributes
          end

          should respond_with(:success)
          should assign_to(:user)
        end

        context 'with invalid data' do
          setup do
            post :create, :user => User.gen(:email => nil).attributes
          end

          should respond_with(:success)
          should render_with_layout
          should render_template(:new)
        end
      end

      context 'on GET to :show' do
        should 'show user' do
          get :show, :id => @user.to_param
          assert_response :success
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @user.to_param
          assert_response :success
          assert_not_nil assigns(:user)
        end
      end

      context 'on PUT to :update' do
        should 'update user' do
          put :update, :id => @user.to_param, :user => @user.attributes
          assert_redirected_to user_path(assigns(:user))
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          @another_user = User.gen
        end

        should 'destroy user' do
          assert @another_user.valid?
          assert_difference('User.count', -1) do
            delete :destroy, :id => @another_user.to_param
          end
          assert_redirected_to users_path
        end
      end

    end

    context 'while unauthed' do
      setup do
        User.auto_migrate!
        @user = User.gen
        raise "INVALID #{@user.errors.inspect}" unless @user.valid?
      end

      context 'on GET to :index' do
        should 'require login' do
          get :index
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :new' do
        should "should get new" do
          get :new
          assert_response(:success)
        end
      end

      context 'on GET to :show' do
        should 'require login' do
          get :show, :id => @user.to_param
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :edit' do
        should 'require a login' do
          get :edit, :id => @user.to_param
          assert_redirected_to new_user_session_path
        end
      end

      context 'on PUT to :update' do
        should 'require a login' do
          put :update, :id => @user.to_param, :user => @user.attributes
          assert_redirected_to new_user_session_path
        end
      end

      context 'on DELETE to :destroy' do
        should 'require a login' do
          delete :destroy, :id => @user.to_param
          assert_redirected_to new_user_session_path
        end
      end
    end
  end
end
