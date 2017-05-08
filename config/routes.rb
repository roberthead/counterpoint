Rails.application.routes.draw do
  get 'sandboxes/show'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]

  resource :home, only: [:show]
  resource :style_guide, only: [:show]
  resource :about, only: [:show]
  resource :sandbox, only: [:show]

  resources :notes, only: [:create, :destroy]

  root to: 'homes#show'
end
