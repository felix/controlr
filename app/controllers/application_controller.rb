require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  prepend_before_filter :setup_globals

  protected

  def setup_globals

    authenticate_user!

    if user_signed_in?
      @account = Account.get(session[:current_account_id] ||= current_user.account.id)
      session[:current_domain_id] = params.delete(:change_domain) if params[:change_domain]
      if session[:current_domain_id]
        @domain = @account.domains.get(session[:current_domain_id])
        session[:current_domain_id] = nil unless @domain
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
