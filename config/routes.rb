Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root "index#welcome"
  get '/', to: 'index#welcome'
  get 'transactions/new_transfer', to: 'transactions#new_transfer'
  get 'transactions/new_saving', to: 'transactions#new_saving'
  get 'transactions/:id/confirm_transaction', to: 'transactions#confirm_transaction',
                                              as: 'confirm_transaction'
  post 'transactions/create_deposit', to: 'transactions#create_deposit', as: 'create_deposit'
  get 'api/v1/transactions/date', to: 'api/v1/transactions#date'
  get 'exchanges/test', to: 'exchanges#get_coins'
  get 'exchanges/test_buy', to: 'exchanges#buy_btf'

  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      get 'api_token'
    end
    resources :accounts, only: [:show, :index] do
      resources :transactions, only: [:index]
    end
  end
  resources :transactions, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      resources :transactions, only: [:index]
    end
  end
end
