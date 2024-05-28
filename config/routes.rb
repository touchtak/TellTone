Rails.application.routes.draw do

  get 'relationships/followings'
  get 'relationships/followers'
  root to: 'homes#top'

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }

  resources :viewers, only: [:new, :create, :show, :index, :edit]
  post 'viewers/new' => 'viewers#create', as: "viewer_create"
  patch 'viewers/:id/edit' => 'viewers#update', as: "viewer_update"
  resources :creators, only: [:new, :create, :show, :index, :edit]
  post 'creators/new' => 'creators#create', as: "creator_create"
  patch 'creators/:id/edit' => 'creators#update', as: "creator_update"
  # フォロー機能
  post 'viewer/:id/follow' => 'relationships#viewer_relation_create', as: "viewer_follow"
  post 'creator/:id/follow' => 'relationships#creator_relation_create', as: "creator_follow"
  delete 'viewer/:id/unfollow' => 'relationships#viewer_relation_destroy', as: "viewer_unfollow"
  delete 'creator/:id/unfollow' => 'relationships#creator_relation_destroy', as: "creator_unfollow"
  get 'viewer/:id/followings' => 'relationships#followings', as: "followings"
  get 'viewer/:id/followers' => 'relationships#viewer_followers', as: "viewer_followers"
  get 'creator/:id/followers' => 'relationships#creator_followers', as: "creator_followers"

  # 検索機能
  get 'search_form' => 'searches#search_form', as: "search_form"
  get 'post_search_form' => 'searches#post_search_form', as: "post_search_form"
  get 'search' => 'searches#search'
  get 'tag_search_form' => 'searches#tag_search_form', as: "tag_search_form"
  get 'tag_search' => 'searches#tag_search', as: "tag_search"
  get 'emotion_search_form' => 'searches#emotion_search_form', as: "emotion_search_form"
  get 'emotion_search' => 'searches#emotion_search', as: "emotion_search"

  # 投稿関連
  resources :posts, only: [:show, :index, :new, :destroy] do
    get 'previous', on: :collection
    get 'next', on: :collection
  end
  get 'creators/:id/works' => 'posts#work_index', as: "work_index"

  # 新規投稿
  get 'viewer_post/new' => 'posts#viewer_post_new', as: "new_viewer_posts"
  post 'viewer_post/new' => 'posts#viewer_post_create', as: "viewer_posts"
  get 'creator_post/new' => 'posts#creator_post_new', as: "new_creator_posts"
  post 'creator_post/new' => 'posts#creator_post_create', as: "creator_posts"

  # コメント機能
  get 'posts/:id/comment/new' => 'comments#new', as: "new_comment"
  post 'posts/:id/comment/new' => 'comments#create', as: "comment"
  delete 'comment/:id/delete' => 'comments#destroy', as: "comment_destroy"

  # いいね機能
  get 'viewer/:id/like_posts' => 'likes#like_posts', as: "like_posts"
  get 'viewer/:id/like_creator_posts' => 'likes#like_creator_posts', as: "like_creator_posts"
  post 'posts/:id/like' => 'likes#create', as: "like"
  delete 'posts/:id/like/delete' => 'likes#destroy', as: "like_destroy"

  # リクエスト機能
  get 'creator/:id/requests' => 'requests#index', as: "requests"
  get 'creator/:id/requests/new' => 'requests#new', as: "new_request"
  post 'creator/:id/requests/new' => 'requests#create', as: "request"
  get 'creator/:id/requests/edit' => 'requests#edit', as: "edit_request"
  patch 'creator/:id/requests/edit' => 'requests#update', as: "update_request"
  delete 'creator/:id/request' => 'requests#destroy', as: "destroy_request"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
