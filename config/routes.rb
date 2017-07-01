Rails.application.routes.draw do
  resources :accounts do
    resources :charges
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "accounts#index"
end
