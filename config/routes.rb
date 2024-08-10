# frozen_string_literal: true

Rails.application.routes.draw do
  root 'game_sessions#index'

  resources :game_sessions, only: %i[index new create]

  resource :game, only: %i[show] do
    post :next_question, on: :member
    get :game_over, on: :member
    get :retry, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :game_sessions, only: %i[index show], param: :username
    end
  end

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
end
