# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :v1, defaults: { format: :json } do
    scope ':account_id' do
      resources :contacts, only: [:index]

      resources :organizations, only: [:index, :show, :create, :update] do
        resources :contacts, only: [:create, :update, :destroy]
      end
    end

    resources :accounts, only: [:index, :create, :update]

    resource :sessions, only: [:create, :destroy, :show]
    resources :users, only: [:create]
  end
end
