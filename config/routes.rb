Rails.application.routes.draw do

  resources :materials
  resources :accounts do
    collection do
      get :batch_new
      post :batch_create
      get :email_addresses
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
  get '/billing/report', to: 'billing#report'
  get '/billing/detail_report', to: 'billing#detail_report'
  get '/billing/usage_report', to: 'billing#usage_report'

  resources :chargefiles, only: [:index, :show, :create] do
    member do
      get :download
    end
  end

  root "accounts#index"
end
