require 'dm-rails/middleware/identity_map'
class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  private

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
