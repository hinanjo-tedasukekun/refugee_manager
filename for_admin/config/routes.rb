ForAdmin::Engine.routes.draw do
  root 'welcome#index'

  resources :refugees, only: %i(index show)
  resources :families, only: %i(index show edit update)
  resources :notices

  get 'shelter/edit' => 'shelter#edit'
  get 'shelter' => 'shelter#show'
  patch 'shelter' => 'shelter#update'

  namespace :refugees do
    get ':id/basic-info/edit' => 'basic_info#edit', as: 'edit_basic_info'
    patch ':id/basic-info' => 'basic_info#update', as: 'basic_info'

    get ':id/password/edit' => 'password#edit', as: 'edit_password'
    patch ':id/password' => 'password#update', as: 'password'

    get ':id/vulnerabilities/edit' => 'vulnerabilities#edit', as: 'edit_vulnerabilities'
    patch ':id/vulnerabilities' => 'vulnerabilities#update', as: 'vulnerabilities'

    get ':id/supplies/edit' => 'supplies#edit', as: 'edit_supplies'
    patch ':id/supplies' => 'supplies#update', as: 'supplies'

    get ':id/allergens/edit' => 'allergens#edit', as: 'edit_allergens'
    patch ':id/allergens' => 'allergens#update', as: 'allergens'

    get ':id/skills/edit' => 'skills#edit', as: 'edit_skills'
    patch ':id/skills' => 'skills#update', as: 'skills'
  end

  get 'list_of_refugees' => 'list_of_refugees#index'
  get 'list_of_refugees/all_refugees'
  get 'list_of_refugees/refugees_not_at_home'
  get 'list_of_refugees/refugees_at_home'
end
