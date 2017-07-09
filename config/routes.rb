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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "accounts#index"
end
