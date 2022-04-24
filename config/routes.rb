Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  #get 'sessions/new'
  #get 'sessions/create'
  #get 'sessions/destroy'
  #get 'chats/new'
  resources :messages
  resources :chats
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  root 'chats#index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  put 'chatupdate', to: 'chats#update', as: 'chatupdate'
  put 'userupdate', to: 'users#update', as: 'userupdate'
  put 'messageupdate', to: 'messages#update', as: 'messageupdate'
end
