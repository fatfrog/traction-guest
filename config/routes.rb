Rails.application.routes.draw do
  resource :users, only: [:create, :destroy]
  resources :user_searches, only: [:index]
end
