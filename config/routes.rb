Bsa::Application.routes.draw do
  root :to => "user/dashboard#show"

  devise_for :users, controllers: {:registrations => "registrations"}

  namespace :admin do
    resources :users do
      resources :votings, only: [:create, :update], controller: 'user/votings'
      resources :contributions, controller: 'user/contributions'
      resource :rights, controller: 'user/rights'
    end
  end

  namespace :user do
    resource :dashboard, only: [:show], controller: 'dashboard'
    resource :membership, only: [:create], controller: 'membership'
    resources :votings, only: [] do
      resources :votes, only: [:create]
    end
  end
end
