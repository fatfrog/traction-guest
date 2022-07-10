Rails.application.routes.draw do
  resource :users, only: [:create, :destroy]
  resources :users_search, only: [:index]
end
