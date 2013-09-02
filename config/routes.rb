Bsa::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: {:registrations => "registrations"}


  namespace :admin do
    resources :users do
      resources :contributions, controller: 'user/contributions'
    end
  end
end
