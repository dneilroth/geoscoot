Rails.application.routes.draw do
  resources :scooters, only: [:index, :update] do
    collection do
      put :bulk_unlock
      get :active
    end

    resources :tickets, only: [:create]
  end
end
