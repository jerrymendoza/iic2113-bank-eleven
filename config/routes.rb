Rails.application.routes.draw do
  root to: "index#welcome"
  get 'transactions/new_transfer', to: 'transactions#new_transfer'
  get 'transactions/new_saving', to: 'transactions#new_saving'
  get 'transactions/send_email', to: 'transactions#send_email', as: 'transactions_send_email'
  get 'transactions/:id/confirm_transaction', to: 'transactions#confirm_transaction', as: 'confirm_transaction'
  post 'transactions/create_deposit', to: 'transactions#create_deposit', as: 'create_deposit'
  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
    end
  end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: "users/registrations" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :user do
    resources :accounts, only: [:show, :index] do
      resources :transactions, only: [:index]
    end
  end
  resources :transactions, only: [:new, :create]
end
