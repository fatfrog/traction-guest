Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :destroy] do
        resources :search, only: [:index]
      end
    end
  end
end
