Controlr::Application.routes.draw do
  resources :settings

  devise_for :users, :path_names => {
    :sign_in => 'login',
    :sign_out => 'logout',
    :password => 'secret',
    :confirmation => 'verification',
    :registration => 'register',
    :sign_up => 'signup'
  }
=begin
  devise_for :users
=end

  resource :dashboard, :only => [:index]

  resources :domains do
    resources :aliases
    resources :mailboxes
    resources :dns, :controller => 'domain_records'
  end

  resources :accounts do
#    resources :domains
  end

  resources :users

  resources :permissions
  resources :roles do
    collection do
      get 'report'
    end
    resources :permissions
  end

#  resources :clients

#  resources :servers
#  resources :ip_addresses
#  resources :services

  root :to => 'dashboard#index'

end
