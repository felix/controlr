require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  context 'Accounts Controller' do
    setup do
      start_transaction

      @admin = User.gen(:role => 'administrator')
      @super = User.gen(:role => 'super')
      @user = User.gen(:role => 'user', :account => @admin.account)
      @account = @admin.account
      raise "INVALID #{@account.errors.inspect}" unless @account.valid?
    end

    def teardown
      rollback_transaction
    end

    # all general tests to be performed as admin
    #
    context 'while authed as super' do
      setup do
        sign_in @super
        @request.session[:current_account_id] = @account.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:accounts)
      end

      context 'on POST to :new' do
        setup do
          post :create, :account => Account.make.attributes
        end

        should('redirect to account dashboard'){ redirect_to account_path(assigns(:account)) }
        should assign_to(:account)

        should 'create default NS records' do
          assert assigns(:account).default_name_records.all(:type => 'NS').count >= 2
        end

      end

      context 'on POST to :new with invalid data' do
        should 'return to form' do
          post :create, :account => Account.make(:name => nil).attributes
          assert_response :success
          assert_not_nil assigns(:account)
        end
      end

      context 'on GET to :show' do
        setup do
          get :show, :id => @account.id
        end

        should respond_with(:success)
        should assign_to(:account)
      end

      context 'on GET to :show with invalid data' do
        setup do
          get :show, :id => 8884848
        end

        should('redirect to account path'){ redirect_to accounts_path }
      end

      context 'on GET to :edit' do
        setup do
          get :edit, :id => @account.id
        end

        should 'get edit' do
          assert_response :success
          assert_not_nil assigns(:account)
        end
      end

      context 'on PUT to :update' do
        should 'update account' do
          put :update, {:id => @account.to_param, :account => @account.attributes}
          assert_redirected_to account_path(@account)
        end
      end

      context 'on DELETE to :destroy' do
        should 'destroy account' do
          assert_difference('Account.count', -1) do
            delete :destroy, :id => @account.id
          end
          assert_redirected_to accounts_path
        end
      end
    end

    context 'while authed as admin' do
      setup do
        sign_in @admin
        @request.session[:current_account_id] = @account.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should('redirect to dashboard'){ redirect_to root_path }
      end

      context 'on GET to :edit' do
        setup do
          get :edit, :id => @account.id
        end

        should 'get edit' do
          assert_response :success
          assert_not_nil assigns(:account)
        end
      end
    end

    context 'while authed as user' do
      setup do
        sign_in @user
        @request.session[:current_account_id] = @account.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should('redirect to dashboard'){ redirect_to root_path }
      end
    end

    context 'while unauthed' do

      context 'on GET to :index' do
        setup do
          get :index
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end

      context 'on GET to :new' do
        setup do
          get :new
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end

      context 'on GET to :show' do
        setup do
          get :show, :id => @admin.to_param
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end

      context 'on GET to :edit' do
        setup do
          get :edit, :id => @admin.to_param
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end

      context 'on PUT to :update' do
        setup do
          put :update, :id => @admin.to_param, :account => @admin.attributes
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @admin.to_param
        end
        should('redirect to login'){ redirect_to new_user_session_path }
      end
    end
  end
end
