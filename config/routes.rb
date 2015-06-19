Headlines::Engine.routes.draw do
  resources :domains, only: %i(show)
  resources :industries, only: %i(index)

  root to: "industries#index"
end
