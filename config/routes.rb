Controlr::Application.routes.draw do

  resources :domains do
    resources :emails
    resources :dns, :controller => 'domain_records'
  end

  resources :accounts
#  resources :users
  devise_for :users

  resources :clients

  resources :servers
  resources :ip_addresses
  resources :services

  #resources :postfixes, :as => :services, :controller => :services

   root :to => "welcome#index"

end
