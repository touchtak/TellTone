Rails.application.routes.draw do

  root to: 'homes#top'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }

  resources :viewers, only: [:new, :create, :show, :index, :edit, :update]
  resources :creators, only: [:new, :create, :show, :index, :edit, :update]

  get "search" => "searches#search"

  resources :posts, only: [:show, :index, :new, :destroy]
  get '/viewer_post/new' => 'posts#viewer_post_new', as: "new_viewer_posts"
  post '/viewer_post' => 'posts#viewer_post_create', as: "viewer_posts"
  get '/creator_post/new' => 'posts#creator_post_new', as: "new_creator_posts"
  post '/creator_post' => 'posts#creator_post_create', as: "creator_posts"

  get '/posts/:id/comment/new' => 'comments#new', as: "new_comment"
  post '/posts/:id/comment' => 'comments#create', as: "comment"
  delete '/comment/:id/delete' => 'comments#destroy', as: "comment_destroy"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
