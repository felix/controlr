require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
    #render :file => "#{Rails.root}/public/403.html", :status => 403
  end

  before_filter :authenticate_user!
  append_before_filter :setup_globals

  protected

  def setup_globals
    if user_signed_in?
      session[:current_account_id] ||= current_user.account.id
      @account = Account.get(session[:current_account_id])
      if session[:current_domain_id]
        @domain = @account.domains.get(session[:current_domain_id])
      end
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
