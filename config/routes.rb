Rails.application.routes.draw do

  resources :materials
  resources :accounts do
    collection do
      get :batch_new
      post :batch_create
    end
    resources :charges, only: [:index, :create, :update, :destroy]
  end

  get '/billing', to: 'billing#index'

  # Don't need this for local version
  #  get 'sessions/new'
  #  get '/login', to: 'sessions#new'
  #  post '/login', to: 'sessions#create'
  #  delete '/logout', to: 'sessions#destroy'

  root "accounts#index"
end
