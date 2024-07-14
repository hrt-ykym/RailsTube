Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/signup', to: 'users#new'
  resources :users, only: [:new, :create, :show]
end