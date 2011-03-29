require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  context 'Domains Controller' do
    setup do
      start_transaction

      @admin = User.gen(:role => 'administrator')
      @account = @admin.account
      raise "INVALID #{@admin.errors.inspect}" unless @admin.valid?
      @domain = @account.domains.gen
      raise "INVALID #{@domain.errors.inspect}" unless @domain.valid?
    end

    def teardown
      rollback_transaction
    end

    context 'while authed as admin' do
      setup do
        sign_in @admin
        @request.session[:current_account_id] = @domain.account.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:domains)
      end

      context 'on POST to :new' do
        should 'create new domains' do
          post :create, :domain => @account.domains.make.attributes
          assert_redirected_to domains_path
          assert_not_nil assigns(:domain)
        end

        context 'with invalid data' do
          should 'return to form' do
            post :create, :domain => @account.domains.make(:name => nil).attributes
            assert_response :success
            assert_not_nil assigns(:domain)
          end
        end
      end

      context 'on GET to :show' do
        should 'show domain' do
          get :show, :id => @domain.id
          assert_response :success
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @domain.id
          assert_response :success
          assert_not_nil assigns(:domain)
        end
      end

      context 'on PUT to :update' do
        should 'update domain' do
          put :update, {:id => @domain.to_param, :domain => @domain.attributes}
          assert_redirected_to domains_path
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          @another_domain = @admin.account.domains.gen
          raise @another_domain.inspect unless @another_domain.valid?
        end

        should 'destroy domain if no children' do
          assert @another_domain.valid?
          assert_difference('Domain.count', -1) do
            delete :destroy, :id => @another_domain.to_param
          end
          assert_redirected_to domains_path
        end

        should 'not destroy domain from another account' do
          @another_domain.account = Account.gen
          @another_domain.save
          assert_no_difference('Domain.count') do
            delete :destroy, :id => @another_domain.to_param
          end
          assert_redirected_to domains_path
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
          put :update, :id => @admin.to_param, :domain => @admin.attributes
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
