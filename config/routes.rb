Rails.application.routes.draw do
  root to: 'songs#new'
  resources :songs do
    get 'listen'
  end
end
