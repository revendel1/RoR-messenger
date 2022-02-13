Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :messages
  resources :chats
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  root 'chats#index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  post 'chats/update'
end
