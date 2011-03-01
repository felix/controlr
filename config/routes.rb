Controlr::Application.routes.draw do
=begin
  devise_for :users, :path_names => {
    :sign_in => 'login',
    :sign_out => 'logout',
    :password => 'secret',
    :confirmation => 'verification',
    :registration => 'register',
    :sign_up => 'signup'
  }
=end
  devise_for :users

  resource :dashboard, :only => [:index]

  resources :domains do
    resources :emails
    resources :dns, :controller => 'domain_records'
  end

  resources :accounts do
    resources :domains
  end

  resources :users
  resources :roles

  resources :clients

  resources :servers
  resources :ip_addresses
  resources :services

  #resources :postfixes, :as => :services, :controller => :services

   root :to => 'dashboard#index', :as => 'home'

end
