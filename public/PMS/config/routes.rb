Rails.application.routes.draw do
  devise_for :admins, :controllers =>{ sessions: "admins/sessions"}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'task/index'
  root 'home#index'

  devise_for :users, :controllers =>{ registrations: "users/registrations", sessions: "users/sessions"} do
  	get '/users/sign_out' => 'devise/sessions#destroy'
  end
  get 'home/index', to: 'home#index', as: :projects
  get "home/new", to:"home#new", as: :new_project
  post 'home/:id', to: 'home#create'
  get 'home/:id', to: 'home#show', as: :project
  get 'home/:id/edit', to: 'home#edit', as: :edit_project
  patch 'home/:id', to: 'home#update', as: :update1
  delete 'home/:id', to: 'home#destroy' 

  get 'task/index', to: 'task#index' ,as: :tasks
  get "task/:id/new", to:"task#new", as: :new_task
  post 'task/index', to: 'task#create' 
  get 'task/:task_id/edit', to: 'task#edit', as: :edit_task
  patch 'task/:task_id', to: 'task#update', as: :task
   delete 'task/:task_id', to: 'task#destroy'

   get 'attachment/index', to: 'attachment#index' ,as: :attachments
  get "attachment/:id/new", to:"attachment#new", as: :new_attachment
  post 'attachment/index', to: 'attachment#create' 
  get 'attachment/:attachment_id/edit', to: 'attachment#edit', as: :edit_attachment
  patch 'attachment/:attachment_id', to: 'attachment#update', as: :attachment
   delete 'attachment/:attachment_id', to: 'attachment#destroy'
end
