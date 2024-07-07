Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:index, :create] do
    collection do
      get 'filter'
    end
  end

  root "users#index"
end
