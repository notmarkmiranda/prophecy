Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  ## login & session management start
  get "/sign-in", to: "user_authentication#show", as: :user_authentication
  post "/sign-in", to: "user_authentication#create"
  get "/login-code", to: "user_authentication#login_code", as: :user_login_code
  post "/verify-login-code", to: "user_authentication#verify_login_code", as: :verify_login_code

  get "/dashboard", to: "dashboard#show", as: :dashboard

  delete "/logout", to: "user_authentication#destroy", as: :logout
  ## login & session management end

  resources :pools, only: [ :new, :create, :show, :edit, :update ] do
    member do
      resources :memberships, only: [ :new, :create ]
    end
  end

  get "/verify-membership/:token", to: "memberships#verify", as: :verify_membership

  root "pages#index"
end
