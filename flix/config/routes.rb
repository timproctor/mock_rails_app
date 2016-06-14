Rails.application.routes.draw do
  resources :users
  get 'signup', to: 'users#new'

  root "movies#index"
  resources :movies do
    resources :reviews
  end
end
