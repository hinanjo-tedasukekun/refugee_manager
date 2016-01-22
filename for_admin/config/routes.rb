ForAdmin::Engine.routes.draw do
  root 'welcome#index'

  resources :refugees, only: %i(index show)
  resources :families, only: %i(index show edit update)
  resources :notices
end
