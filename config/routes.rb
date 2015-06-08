Headlines::Engine.routes.draw do
  resources :categories, only: %i(index)
end
