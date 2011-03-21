class DashboardController < ApplicationController
  before_filter do
    session[:current_domain_id] = nil
  end

  def index
  end

end
