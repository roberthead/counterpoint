Rails.application.routes.draw do
  resource :home, only: [:show]
  resource :style_guide, only: [:show]
  resource :about, only: [:show]

  resources :compositions

  root to: 'homes#show'
end
