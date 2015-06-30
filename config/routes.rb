Headlines::Engine.routes.draw do
  resources :industries, only: %i(index show) do
    resources :domains, only: %i(show)
  end

  resource :scans, only: %i(show)

  root to: "industries#index"
end
