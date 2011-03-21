require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  context 'Dashboard controller' do
    setup do
      start_transaction
    end

    def teardown
      rollback_transaction
    end

    context 'while authed' do
      setup do
        @user = User.gen
        sign_in @user
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(:success)
        should render_with_layout
        should render_template(:index)

      end
    end

    context 'while unauthed' do
      setup do
        @user = User.gen
      end

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(302)
      end
    end

  end
end
