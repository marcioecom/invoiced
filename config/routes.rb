# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :v1 do
    resources :contacts
    resource :sessions, only: [:create, :destroy, :show]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
