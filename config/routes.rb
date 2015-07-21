Rails.application.routes.draw do

  root 'projects#index'

  resources :projects, path: '/p' do
    get 'closed', as: 'closed'
    resources :tickets, path: '/t', shallow: true do
      get 'self_assign', as: 'self_assign'
      get 'close', as: 'close'
      get 'reopen', as: 'reopen'
      get 'approve', as: 'approve'
      resources :comments, path: '/c', only: :create
    end
  end
  resources :users, path: '/u'
  resources :comments, only: :destroy, path: '/c'

  resources :sessions, only: [:login, :create, :destroy]
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signin', to: 'sessions#login', as: 'signin'
  get 'signout', to: 'sessions#destroy', as: 'signout'

end
