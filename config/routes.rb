Rails.application.routes.draw do
  resources :user, only: [:create]
end
