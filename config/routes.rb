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
  resources :users
  resources :aliases
  resources :mailboxes
  resources :name_records
  resources :config_files do
    member do
      get 'generate'
    end
  end

  resources :roles do
    collection do
      get 'report'
      post 'report'
    end
  end

  root :to => 'dashboard#index'

end
