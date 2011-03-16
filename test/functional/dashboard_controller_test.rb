require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  context 'Dashboard controller' do
    setup do
      User.auto_migrate!
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
