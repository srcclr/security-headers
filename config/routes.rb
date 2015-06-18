Headlines::Engine.routes.draw do
  resources :industries, only: %i(index)
  root to: "industries#index"
end
