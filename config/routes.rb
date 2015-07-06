Headlines::Engine.routes.draw do
  resources :categories, only: %i(index show) do
    resources :domains, only: %i(show)
  end

  resource :scans, only: %i(show)

  root to: "categories#index"
end
