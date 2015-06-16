Headlines::Engine.routes.draw do
  resources :categories, only: %i(index)
  resources :domains, only: %i(show)

  root to: "categories#index"
end
