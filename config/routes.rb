Bsa::Application.routes.draw do

  ComfortableMexicanSofa::Routing.admin(path: '/cms-admin')

  root to: "user/dashboard#show"

  devise_for :users, controllers: {registrations: 'registrations', passwords: 'passwords'}

  namespace :guest do
    resource :dashboard, only: [:show], controller: 'dashboard'
  end

  namespace :user do
    resource :dashboard, only: [:show], controller: 'dashboard'
    resource :membership, only: [:create], controller: 'membership'
    resources :votings, only: [] do
      resources :votes, only: [:create]
    end
  end

  namespace :admin do
    resources :users do
      resource :membership_acceptance, only: [:create], controller: 'user/membership_acceptance'
      resources :votings, only: [:create, :update], controller: 'user/votings'
      resources :contributions, only: [:new, :create, :destroy], controller: 'user/contributions'
      resources :memberships, only: [:update], controller: 'user/memberships'
      resource :rights, controller: 'user/rights'
    end
    resources :forums do
      resources :logins, only: :create
    end
  end

  # Make sure this routeset is defined last
  ComfortableMexicanSofa::Routing.content(path: '/', sitemap: false)
end
