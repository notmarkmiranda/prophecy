Rails.application.routes.draw do
  get "pages/index"
  get "up" => "rails/health#show", as: :rails_health_check

  get "/sign-in-or-up", to: "user_authentication#show", as: :user_authentication
  post "/sign-in-or-up", to: "user_authentication#create"
  get "/login-code", to: "user_authentication#login_code", as: :user_login_code
  post "/verify-login-code", to: "user_authentication#verify_login_code", as: :verify_login_code

  get "/dashboard", to: "dashboard#show", as: :dashboard

  root "pages#index"
end
