Rails.application.routes.draw do
  
  root to: 'home#index'

  get 'login' => 'sessions#new', as: :login
  get 'logout' => 'sessions#destroy', as: :logout

  get 'auth/:provider/callback' => 'sessions#create'
  get 'auth/failure' => 'sessions#failure'

  resources :users, only: [:update]

end
