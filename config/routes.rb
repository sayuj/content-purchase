Rails.application.routes.draw do
  resources :movies
  resources :seasons
  resources :contents
  resources :purchases
end
