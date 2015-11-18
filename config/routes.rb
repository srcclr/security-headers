Headlines::Engine.routes.draw do
  resources :categories, only: %i(index show) do
    resources :domains, only: %i(show)
  end

  resource :scans, only: %i(show)

  root to: "categories#index"
end

Rails.application.routes.draw do
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      namespace :domains do
        post "scan", to: "scans#create"
      end
    end
  end
end
