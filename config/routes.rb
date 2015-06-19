Headlines::Engine.routes.draw do
  resources :industries, only: %i(index) do
    resources :domains, only: %i(show)
  end

  root to: "industries#index"
end
