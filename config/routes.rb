Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :destroy]
      resources :user_searches, only: [:index]
    end
  end
end
