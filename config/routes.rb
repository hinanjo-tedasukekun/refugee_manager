Rails.application.routes.draw do
  get 'notices/index'

  get 'notices/show'

  mount ForAdmin::Engine => '/', constraints: { subdomain: 'admin' }

  constraints subdomain: '' do
    root 'welcome#index'

    get 'login' => 'refugee_sessions#new'
    post 'login' => 'refugee_sessions#create'
    delete 'logout' => 'refugee_sessions#destroy'

    get 'profile' => 'profile#show'
    get 'profile/new' => 'profile#new'
    post 'profile/new' => 'profile#create'

    resources :notices, only: [:index, :show]

    namespace :profile do
      get 'basic-info' => 'basic_info#edit'
      patch 'basic-info' => 'basic_info#update'

      get 'password' => 'password#edit'
      patch 'password' => 'password#update'

      get 'vulnerabilities' => 'vulnerabilities#edit'
      patch 'vulnerabilities' => 'vulnerabilities#update'

      get 'supplies' => 'supplies#edit'
      patch 'supplies' => 'supplies#update'

      get 'allergens' => 'allergens#edit'
      patch 'allergens' => 'allergens#update'

      get 'skills' => 'skills#edit'
      patch 'skills' => 'skills#update'
    end
  end
end
