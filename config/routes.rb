Rails.application.routes.draw do
  get 'abouts/show'

  resource :home, only: [:show]
  resource :about, only: [:show]

  root to: 'homes#show'
end
