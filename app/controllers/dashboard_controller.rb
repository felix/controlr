class DashboardController < ApplicationController

  before_filter do
    session[:current_domain_id] = nil
    @domain = nil if @domain
  end

  def index
  end

end
