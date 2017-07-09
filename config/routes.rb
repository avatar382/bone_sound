Rails.application.routes.draw do
  get 'sessions/new'

  resources :materials
  resources :accounts do
    collection do
      get :batch_new
      post :batch_create
    end
    resources :charges, only: [:index, :create, :update, :destroy]
  end

  get '/billing', to: 'billing#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root "accounts#index"
end
