Controlr::Application.routes.draw do

  devise_for :users, :path_names => {
    :sign_in => 'login',
    :sign_out => 'logout',
    :password => 'secret',
    :confirmation => 'verification',
    :registration => 'register',
    :sign_up => 'signup'
  }

  resource :dashboard, :only => [:index]

  resources :accounts
  resources :domains do
    collection do
      post 'switch'
    end
  end
  resources :aliases
  resources :mailboxes
#  resources :dns, :controller => 'domain_records'

  resources :users
  #resources :settings

  resources :roles do
    collection do
      get 'report'
      post 'report'
    end
  end

#  resources :clients

#  resources :servers
#  resources :ip_addresses
#  resources :services

  root :to => 'dashboard#index'

end
