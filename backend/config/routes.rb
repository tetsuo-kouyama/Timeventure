Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :create
      resource :session, only: %i[create destroy]

      # 現在ログインしている自分自身の情報を取得するためのAPI
      get "me", to: "users#me"

      # ゲストログイン用API
      post "guest_login", to: "guest_sessions#create"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
