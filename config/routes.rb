Headlines::Engine.routes.draw do
  resources :categories, only: %i(index)

  root to: "categories#index"
end
