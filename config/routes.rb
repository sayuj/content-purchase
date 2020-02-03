Rails.application.routes.draw do
  resources :movies, only: [:index]
  resources :seasons, only: [:index]
  resources :contents, only: [:index]
  resources :purchases, only: [:create]
  resources :users, only: [] do
    resource :library, only: [:show]
  end
end
