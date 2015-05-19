Rails.application.routes.draw do

  root 'projects#index'

  resources :projects, path: '/p' do
    resources :tickets, path: '/t'
    get :autocomplete_user_name, on: :collection
  end
  resources :users, path: '/u'

  resources :sessions, only: [:login, :create, :destroy]
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signin', to: 'sessions#login', as: 'signin'
  get 'signout', to: 'sessions#destroy', as: 'signout'

end
