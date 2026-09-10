Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :create
      resource :session, only: %i[create destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
