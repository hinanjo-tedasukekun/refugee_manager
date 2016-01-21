ForAdmin::Engine.routes.draw do
  root 'welcome#index'

  resources :refugees, only: [:index, :show]
  resources :notices
end
