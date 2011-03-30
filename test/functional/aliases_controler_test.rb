require 'test_helper'

class AliasesControllerTest < ActionController::TestCase
  context 'Aliases Controller' do
    setup do
      start_transaction

      @admin = User.gen(:role => 'administrator')
      @domain = @admin.account.domains.gen
      raise "INVALID #{@admin.errors.inspect}" unless @admin.valid?
      @alias = @domain.aliases.gen
      raise "INVALID #{@alias.errors.inspect}" unless @alias.valid?
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
        should assign_to(:aliases)
      end

      context 'on POST to :new' do
        should 'create new aliases' do
          post :create, :alias => @domain.aliases.make.attributes
          assert_redirected_to aliases_path
          assert_not_nil assigns(:alias)
        end

        context 'with invalid data' do
          should 'return to form' do
            post :create, :alias => @domain.aliases.make(:email=> nil).attributes
            assert_response :success
            assert_not_nil assigns(:alias)
          end
        end
      end

      context 'on GET to :show' do
        should 'show alias' do
          get :show, :id => @alias.id
          assert_redirected_to edit_alias_path(@alias)
        end

        should 'redirect to list if not found' do
          get :show, :id => 45484
          assert_redirected_to aliases_path
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @alias.id
          assert_response :success
          assert_not_nil assigns(:alias)
        end
      end

      context 'on PUT to :update' do
        should 'update alias' do
          put :update, :id => @alias.to_param, :alias => @alias.attributes
          assert_redirected_to aliases_path
        end
      end

      context 'on DELETE to :destroy' do
        should 'destroy alias' do
          assert_difference('alias.count', -1) do
            delete :destroy, :id => @alias.to_param
          end
          assert_redirected_to aliases_path
        end

        should 'not destroy alias from another domain' do
          another_domain = @admin.account.domains.gen
          another_alias = another_domain.aliases.gen
          assert_no_difference('alias.count') do
            delete :destroy, :id => another_alias.to_param
          end
          assert_redirected_to aliases_path
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
          put :update, :id => @admin.to_param, :alias => @admin.attributes
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
