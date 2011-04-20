require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  context 'Domains Controller' do
    setup do
      start_transaction

      @admin = User.gen(:role => 'administrator')
      @super = User.gen(:role => 'super')
      @user = User.gen(:role => 'user', :account => @admin.account)
      @account = @admin.account
      raise "INVALID #{@admin.errors.inspect}" unless @admin.valid?
      @domain = Domain.gen(:account => @account)
      raise "INVALID #{@domain.errors.inspect}" unless @domain.valid?
    end

    def teardown
      rollback_transaction
    end

    # all general tests to be performed as admin
    #
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
        setup do
          post :create, :domain => @account.domains.make.attributes
        end

        should('redirect to domain dashboard'){ redirect_to domain_path(assigns(:domain)) }
        should assign_to(:domain)

        should 'create default aliases' do
          assert_not_nil assigns(:domain).aliases
        end
      end

      context 'on POST to :new with invalid data' do
        should 'return to form' do
          post :create, :domain => @account.domains.make(:name => nil).attributes
          assert_response :success
          assert_not_nil assigns(:domain)
        end
      end

      context 'on GET to :show' do
        setup do
          get :show, :id => @domain.id
        end

        should respond_with(:success)
        should assign_to(:domain)
      end

      context 'on GET to :show with invalid data' do
        setup do
          get :show, :id => 8884848
        end

        should('redirect to domain path'){ redirect_to domains_path }
      end

      context 'on GET to :edit' do
        setup do
          @request.session[:current_domain_id] = @domain.id
          get :edit, :id => @domain.id
        end

        should 'get edit' do
          assert_response :success
          assert_not_nil assigns(:domain)
        end

        should 'not show account selector' do
          assert_select 'select#domain_account_id', false
        end
      end

      context 'on PUT to :update' do
        should 'update domain' do
          put :update, {:id => @domain.to_param, :domain => @domain.attributes}
          assert_redirected_to domain_path(@domain)
        end

        should 'not change passhash if not entered' do
          old_hash = @domain.passhash
          put :update, :id => @domain.to_param, :domain => @domain.attributes.merge(:passhash => nil)
          mb = Domain.get(@domain.id)
          assert mb.passhash == old_hash
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          @another_domain = Domain.gen(:account => @admin.account)
          raise @another_domain.inspect unless @another_domain.valid?
        end

        should 'destroy domain' do
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

    context 'while authed as super' do
      setup do
        sign_in @super
        @request.session[:current_account_id] = @domain.account.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:domains)

        should 'show ALL domains for account' do
          assert_select 'form.auto-submit option' do
            assert_select '[value=?]', /\d+/, {:count => @domain.account.domains.size}
          end
        end
      end

      context 'on GET to :edit' do
        setup do
          get :edit, :id => @domain.id
        end

        should 'get edit' do
          assert_response :success
          assert_not_nil assigns(:domain)
        end

        should 'show account selector' do
          assert_select 'select#domain_account_id', true
        end
      end
    end

    context 'while authed as user' do
      setup do
        @user.domains << @domain
        @user.save
        sign_in @user
        @request.session[:current_account_id] = @domain.account.id
        @request.session[:current_domain_id] = @domain.id
      end

      context 'on GET to :index' do
        setup do
          d1 = 3.of {Domain.gen(:account => @user.account)}
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:domains)

        should 'show only domains for user' do
          assert_select 'form.auto-submit option' do
            assert_select '[value=?]', /\d+/, {:count => @user.domains.count}
          end
        end
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
          put :update, :id => @admin.to_param, :domain => @admin.attributes
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
