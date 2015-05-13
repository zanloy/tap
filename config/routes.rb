Rails.application.routes.draw do

  root 'home#index'

  resources :projects, path: '/p'
  resources :users

  resources :sessions, only: [:login, :create, :destroy]
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signin', to: 'sessions#login', as: 'signin'
  get 'signout', to: 'sessions#destroy', as: 'signout'

end
