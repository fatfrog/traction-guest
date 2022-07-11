Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :destroy] do
        resources :search, only: [:index], module: 'users'
      end
    end
  end
end
