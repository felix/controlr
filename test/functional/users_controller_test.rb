require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'Users Controller' do
    setup do
      start_transaction
      @admin = User.gen(:role => 'administrator')
      raise "INVALID #{@admin.errors.inspect}" unless @admin.valid?
    end

    def teardown
      rollback_transaction
    end

    context 'while authed as admin' do
      setup do
        sign_in @admin
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
        should 'create new users' do
          post :create, :user => @admin.account.users.make.attributes.merge(
            :password => 'blahblah',
            :password_confirmation => 'blahblah'
          )
          assert_redirected_to users_path
          assert_not_nil assigns(:user)
        end

        context 'with invalid data' do
          should 'return to form' do
            post :create, :user => @admin.account.users.make(:email => nil).attributes.merge(
              :password => 'blahblah',
              :password_confirmation => 'blahblah'
            )
            assert_response :success
            assert_not_nil assigns(:user)
          end
        end
      end

      context 'on GET to :show' do
        should 'show user' do
          get :show, :id => @admin.to_param
          assert_redirected_to edit_user_path(@admin)
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @admin.to_param
          assert_response :success
          assert_not_nil assigns(:user)
        end
      end

      context 'on PUT to :update' do
        should 'update user' do
          put :update, :id => @admin.to_param, :user => @admin.attributes
          assert_redirected_to users_path
        end

        should 'not change password if not entered' do
          old_pass = @admin.encrypted_password
          put :update, :id => @admin.to_param, :user => @admin.attributes.merge(:password => nil)
          assert assigns(:user).encrypted_password == old_pass
        end

      end

      context 'on DELETE to :destroy' do
        setup do
          @another_user = User.gen(:account => @admin.account)
          raise @another_user.inspect unless @another_user.valid?
        end

        should 'destroy user' do
          assert @another_user.valid?
          assert_difference('User.count', -1) do
            delete :destroy, :id => @another_user.to_param
          end
          assert_redirected_to users_path
        end

        should 'not destroy user from another account' do
          @another_user.account = Account.gen
          @another_user.save
          assert_no_difference('User.count') do
            delete :destroy, :id => @another_user.to_param
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
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :show' do
        should 'require login' do
          get :show, :id => @admin.to_param
          assert_redirected_to new_user_session_path
        end
      end

      context 'on GET to :edit' do
        should 'require a login' do
          get :edit, :id => @admin.to_param
          assert_redirected_to new_user_session_path
        end
      end

      context 'on PUT to :update' do
        should 'require a login' do
          put :update, :id => @admin.to_param, :user => @admin.attributes
          assert_redirected_to new_user_session_path
        end
      end

      context 'on DELETE to :destroy' do
        should 'require a login' do
          delete :destroy, :id => @admin.to_param
          assert_redirected_to new_user_session_path
        end
      end
    end
  end
end
