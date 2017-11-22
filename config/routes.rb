Rails.application.routes.draw do

  apipie
  namespace :api do
    namespace :v1 do
      devise_for :users
      get 'search', to: 'search#search'
      get 'location_search', to: 'search#location_search'
      resources :users do
        resources :followed_blogs, only: [:create, :destroy, :index]
      end
      resources :conversations do
        resources :messages, only: [:index, :create]
      end
      resources :trips do
        resources :posts do
          resources :post_pictures, only: [:create, :destroy]
        end
        resources :donation_goals, only: [:create, :edit]
        resources :post_groups, only: [:show, :update]
        resources :gear_lists, only: [:create, :update]
        resources :transactions, only: [:create]
      end
    end
  end

  devise_for :users, :controllers => { :registrations => 'registrations', omniauth_callbacks: 'api/v1/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :users do
    resources :followed_blogs, only: [:index, :create, :destroy]
    get "verification", to: "users#verification", as: "verification"
  end

  get 'search', to: 'search#search'
  get :trip_planner_search, to: "search#location_search"

  resources :trips do
    get "track_route", to: "posts#track_route", as: "track_route"
    resources :posts do
      resources :post_pictures, only: [:new, :create, :destroy]
      get "fetch_images", to: "post_pictures#fetch_images", as: "fetch_images"
    end
    get :fetch_posts
    resources :transactions, only: [:new, :create]
    resources :donation_goals, only: [:new, :create, :update, :edit]
    resources :post_groups, only: [:show, :update]
    resources :gear_lists, only: [:create, :update]
    get "fetch_post/:id", to: "post_groups#fetch_post", as: "fetch_post"
    get "fetch_post_planer/:id", to: "trip_planner#fetch_post", as: "fetch_post_planer"
  end

  resources :conversations do
    resources :messages
  end

end
