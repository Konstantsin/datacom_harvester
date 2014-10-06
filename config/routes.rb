Rails.application.routes.draw do
  root "logs#index"

  resources :logs, only: [:index, :show]

  scope :api do
    resource :companies, only: [] do
      get '/:company_name' => 'api/companies#index'
    end
  end
end
