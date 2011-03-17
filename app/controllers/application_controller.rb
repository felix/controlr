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
    @account = current_user.account if user_signed_in?
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
