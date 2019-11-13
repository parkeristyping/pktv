require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: 'songs#new'
  resources :songs do
    get 'listen'
  end
end
