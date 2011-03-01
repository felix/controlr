require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  context 'Dashboard controller' do
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
        should render_with_layout
        should render_template(:index)

      end
    end

    context 'while unauthed' do

      context 'on GET to :index' do
        setup do
          get :index
        end

        should respond_with(302)
      end
    end

  end
end
