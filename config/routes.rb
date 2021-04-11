Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'scores#home'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'


  
  get '/signup', to: 'users#new'
  resources :users
  resources :scores

  post '/scores/new', to: 'scores#create'
end
