Rails.application.routes.draw do
  root "logs#index"

  resources :logs, only: [:index, :show]
end
