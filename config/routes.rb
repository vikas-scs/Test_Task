Rails.application.routes.draw do
  devise_for :admins
	root "home#index"
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index', to: 'home#index', as: :index
  get "project/new", to:"project#new", as: :new_project
  post 'project/:id', to: 'project#create'
  get 'project/:id', to: 'project#show', as: :project
  get 'project/:id/edit', to: 'project#edit', as: :edit_project
  patch 'project/:id', to: 'project#update', as: :update1
  delete 'project/:id', to: 'project#destroy' 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
