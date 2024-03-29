Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "auth/v1/user"

  namespace :admin do
    namespace :v1 do
      resources :categories
      resources :system_requirements
      resources :coupons
      resources :users
      resources :products
    end
  end
end
