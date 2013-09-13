Bsa::Application.routes.draw do
  root :to => "user/dashboard#show"

  devise_for :users, controllers: {registrations: 'registrations'}

  namespace :admin do
    resources :users do
      resource :membership_acceptance, only: [:create], controller: 'user/membership_acceptance'
      resources :votings, only: [:create, :update], controller: 'user/votings'
      resources :contributions, only: [:new, :create, :destroy], controller: 'user/contributions'
      resources :memberships, only: [:update], controller: 'user/memberships'
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
