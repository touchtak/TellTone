Rails.application.routes.draw do

  get 'relationships/followings'
  get 'relationships/followers'
  root to: 'homes#top'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }

  resources :viewers, only: [:new, :create, :show, :index, :edit, :update]
  resources :creators, only: [:new, :create, :show, :index, :edit, :update]
  # フォロー機能
  post 'viewer/:id/follow' => 'relationships#viewer_relation_create', as: "viewer_follow"
  post 'creator/:id/follow' => 'relationships#creator_relation_create', as: "creator_follow"
  delete 'viewer/:id/unfollow' => 'relationships#viewer_relation_destroy', as: "viewer_unfollow"
  delete 'creator/:id/unfollow' => 'relationships#creator_relation_destroy', as: "creator_unfollow"

  # 検索機能
  get 'search' => 'searches#search'

  # 投稿関連
  resources :posts, only: [:show, :index, :new, :destroy]
  get '/viewer_post/new' => 'posts#viewer_post_new', as: "new_viewer_posts"
  post '/viewer_post' => 'posts#viewer_post_create', as: "viewer_posts"
  get '/creator_post/new' => 'posts#creator_post_new', as: "new_creator_posts"
  post '/creator_post' => 'posts#creator_post_create', as: "creator_posts"

  # コメント機能
  get '/posts/:id/comment/new' => 'comments#new', as: "new_comment"
  post '/posts/:id/comment' => 'comments#create', as: "comment"
  delete '/comment/:id/delete' => 'comments#destroy', as: "comment_destroy"

  # いいね機能
  post '/posts/:id/like' => 'likes#create', as: "like"
  delete '/posts/:id/like/delete' => 'likes#destroy', as: "like_destroy"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
