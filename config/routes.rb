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
  resources :chargefiles, only: [:index, :show, :create] do
    member do
      get :download
    end
  end

  root "accounts#index"
end
