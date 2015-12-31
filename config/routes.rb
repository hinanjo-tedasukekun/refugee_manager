Rails.application.routes.draw do
  root 'welcome#index'

  get 'refugees/query'
  get 'refugees/input-num'

  constraints Subdomain::Admin do
    get 'refugees/count'
    resources :refugees
  end

  constraints subdomain: '' do
    get 'login' => 'refugee_sessions#new'
    post 'login' => 'refugee_sessions#create'
    delete 'logout' => 'refugee_sessions#destroy'

    get 'profile' => 'profile#show'
    get 'profile/new' => 'profile#new'
    post 'profile/new' => 'profile#create'

    namespace :profile do
      get 'basic-info' => 'basic_info#edit'
      patch 'basic-info' => 'basic_info#update'
    end
  end
end
