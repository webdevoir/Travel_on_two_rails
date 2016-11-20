Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :users

  resources :blogs do
    resources :posts

  end

  resources :sessions, only: [:new, :create, :destroy]

end
