Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :users

  get 'search', to: 'search#search'

  resources :trips do
    resources :posts do
      resources :post_pictures, only: [:new, :create, :destroy]
    end
    resources :transactions, only: [:new, :create]
    resources :donation_goals, only: [:new, :create, :update, :edit]
    resources :post_groups, only: [:show, :update]
    get "fetch_post/:id", to: "post_groups#fetch_post", as: "fetch_post"
  end

end
