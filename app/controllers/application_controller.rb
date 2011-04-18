require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  prepend_before_filter :setup_globals
  after_filter :flash_to_headers

  # for XHR, stash flash in response headers to be
  # accessed by JS later
  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message-Notice'] = flash[:notice] unless flash[:notice].blank?
    response.headers['X-Message-Alert'] = flash[:alert] unless flash[:alert].blank?
    flash.discard
  end

  protected

  def setup_globals

    authenticate_user!

    if user_signed_in?
      session[:current_account_id] ||= current_user.account.id
      @account = Account.get(session[:current_account_id])
      return reset_session && redirect_to(root_path) unless @account

      if session[:current_domain_id]
        @domain = @account.domains.get(session[:current_domain_id])
        session[:current_domain_id] = nil unless @domain
      end
    end
  end

  def store_location
    #session[:return_to] = request.fullpath if request.get?
    session[:return_to] = request.referrer if request.get?
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
