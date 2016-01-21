ForAdmin::Engine.routes.draw do
  root 'welcome#index'

  get 'welcome/index'

  resources :refugees, only: [:index, :show]
end
