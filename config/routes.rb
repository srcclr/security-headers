Headlines::Engine.routes.draw do
  resources :categories, only: %i(index show) do
    resources :domains, only: %i(show)
  end

  root to: "categories#index"
end
