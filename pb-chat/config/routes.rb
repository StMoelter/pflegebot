# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: :v1, constraints: ApiConstraint.new(version: 1), defaults: { format: 'json' } do
    resources :sessions, only: :create
  end
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  resources :messages, only: [:index]
  resources :js, only: [:index]
  root 'messages#index'
end
