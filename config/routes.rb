Rails.application.routes.draw do
  resources :posts do
    member do
      get :download
    end
  end
  root "home#index"
end
