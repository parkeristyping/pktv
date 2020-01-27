# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: 'searches#new'
  resources :searches
  resources :songs do
    get 'listen'
  end
end
