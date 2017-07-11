Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :users do
    resources :followed_blogs
  end

  get 'search', to: 'search#search'

  resources :trips do
    resources :posts do
      resources :post_pictures, only: [:new, :create, :destroy]
      get "fetch_images", to: "post_pictures#fetch_images", as: "fetch_images"
    end
    resources :transactions, only: [:new, :create]
    resources :donation_goals, only: [:new, :create, :update, :edit]
    resources :post_groups, only: [:show, :update]
    get "fetch_post/:id", to: "post_groups#fetch_post", as: "fetch_post"
  end

  resources :conversations do
    resources :messages
  end

end
