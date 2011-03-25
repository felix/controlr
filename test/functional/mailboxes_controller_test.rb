require 'test_helper'

class MailboxesControllerTest < ActionController::TestCase
  context 'Mailboxes Controller' do
    setup do
      start_transaction

      @admin = User.gen
      @admin.roles << Role.first(:name => 'admin')
      @admin.save
      @domain = @admin.account.domains.gen
      raise "INVALID #{@admin.errors.inspect}" unless @admin.valid?
      @mailbox = @domain.mailboxes.gen
      raise "INVALID #{@mailbox.errors.inspect}" unless @mailbox.valid?
    end

    def teardown
      rollback_transaction
    end

    context 'while authed as admin' do
      setup do
        sign_in @admin
        @request.session[:current_account_id] = @domain.account.id
        @request.session[:current_domain_id] = @domain.id
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:mailboxes)
      end

      context 'on POST to :new' do
        should 'create new mailboxes' do
          post :create, :mailbox => @domain.mailboxes.make.attributes
          assert_redirected_to mailboxes_path
          assert_not_nil assigns(:mailbox)
        end

        context 'with invalid data' do
          should 'return to form' do
            post :create, :mailbox => @domain.mailboxes.make(:email=> nil).attributes
            assert_response :success
            assert_not_nil assigns(:mailbox)
          end
        end
      end

      context 'on GET to :show' do
        should 'show mailbox' do
          get :show, :id => @mailbox.id
          assert_response :success
        end
      end

      context 'on GET to :edit' do
        should 'get edit' do
          get :edit, :id => @mailbox.id
          assert_response :success
          assert_not_nil assigns(:mailbox)
        end
      end

      context 'on PUT to :update' do
        should 'update mailbox' do
          put :update, {:id => @mailbox.to_param, :mailbox => @mailbox.attributes}
          assert_redirected_to mailboxes_path
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          @another_mailbox = Mailbox.gen(:domain => @domain)
          raise @another_mailbox.inspect unless @another_mailbox.valid?
        end

        should 'destroy mailbox' do
          assert @another_mailbox.valid?
          assert_difference('Mailbox.count', -1) do
            delete :destroy, :id => @another_mailbox.to_param
          end
          assert_redirected_to mailboxes_path
        end

        should 'not destroy mailbox from another domain' do
          @another_mailbox.domain = Domain.gen
          @another_mailbox.save
          assert_no_difference('Mailbox.count') do
            delete :destroy, :id => @another_mailbox.to_param
          end
          assert_redirected_to mailboxes_path
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
          put :update, :id => @admin.to_param, :mailbox => @admin.attributes
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