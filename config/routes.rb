Headlines::Engine.routes.draw do
  resources :categories, only: %i(index)
  get 'headlines' => 'homepages#show'
  root to: "categories#index"
end
