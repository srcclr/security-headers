Headlines::Engine.routes.draw do
  resources :categories, only: %i(index show) do
    resources :domains, only: %i(show)
  end

  resource :scans, only: %i(show)
  resources :favorite_domains, only: %i(index create destroy) do
    resource :email_notifications, only: :update
  end
  get "favorite-domains" => "favorite_domains#index"

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      get "scan", to: "scans#create"
      post "scan", to: "scans#create"
    end
  end

  root to: "categories#index"
end
