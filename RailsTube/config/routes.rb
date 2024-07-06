Rails.application.routes.draw do
  root 'static_pages#home'
  get '/home', to: 'static_pages#home', as: :home
  get '/short', to: 'static_pages#short'
  get '/channels', to: 'static_pages#channels' 
end
