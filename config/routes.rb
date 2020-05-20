Rails.application.routes.draw do
  namespace :api do
    resources :articles
    resources :authors
  end
end
