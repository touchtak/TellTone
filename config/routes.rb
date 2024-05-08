Rails.application.routes.draw do

  root to: 'homes#top'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }

  resources :viewers, only: [:new, :create, :show, :index, :edit, :update]

  resources :posts, only: [:show, :index, :new, :destroy]
  get '/viewer_post/new' => 'posts#viewer_post_new', as: "new_viewer_posts"
  post '/viewer_post' => 'posts#viewer_post_create', as: "viewer_posts"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
