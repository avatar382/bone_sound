Rails.application.routes.draw do

  resources :materials
  resources :accounts do
    collection do
      get :batch_new
      post :batch_create
    end
    member do
      get :access_form
    end
    resources :charges, only: [:index, :create, :update, :destroy] do
      collection do
        get :invoice
      end
    end
  end

  get '/billing', to: 'billing#index'
  resources :chargefiles, only: [:index, :show, :create] do
    member do
      get :download
    end
  end

  root "accounts#index"
end
