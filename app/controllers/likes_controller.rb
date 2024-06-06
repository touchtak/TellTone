class LikesController < ApplicationController
  before_action :current_viewer_existence_before_check
  before_action :set_viewer, only: [:like_posts, :like_creator_posts]

  # いいね一覧
  def like_posts
    likes = Like.where(user_id: @viewer.user_id).sort_by(&:created_at).reverse

    # eachメソッドでの格納用に空の変数を宣言
    like_posts_data = []

    # 投稿をビューワーとクリエイターに分ける
    likes.each do |like|
      if like.creator_post_id.present?
        like_posts_data << CreatorPost.find(like.creator_post_id)
      elsif like.viewer_post_id.present?
        like_posts_data << ViewerPost.find(like.viewer_post_id)
      else
      end
    end

    @like_posts = Kaminari.paginate_array(like_posts_data).page(params[:page]).per(10)
    @followings = (@viewer.viewer_followings + @viewer.creator_followings)
  end

  # クリエイター作品いいね一覧
  def like_creator_posts

    likes = Like.where(user_id: @viewer.user.id).sort_by(&:created_at).reverse

    # eachメソッドでの格納用に空の変数を宣言
    like_creator_works = []

    likes.each do |like|
      if like.creator_post_id.present?
        like_creator_work = CreatorPost.find(like.creator_post_id)
        if like_creator_work.post_image.attached?
          like_creator_works << like_creator_work

        elsif like_creator_work.audio.present?
          like_creator_works << like_creator_work

        else
        end

      else
      end
    end

    like_works_data = like_creator_works
    @like_works = Kaminari.paginate_array(like_works_data).page(params[:page]).per(10)
    @followings = (@viewer.viewer_followings + @viewer.creator_followings)
  end

  def create
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      @post = CreatorPost.find_by(post_numbering_id: params[:id])
      like = Like.new(user_id: current_user.id, creator_post_id: @post.id)


    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      @post = ViewerPost.find_by(post_numbering_id: params[:id])
      like = Like.new(user_id: current_user.id, viewer_post_id: @post.id)

    else
      flash[:notice] = "投稿が存在しません"
    end

    like.save
  end

  def destroy
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      @post = CreatorPost.find_by(post_numbering_id: params[:id])
      like = Like.find_by(user_id: current_user.id, creator_post_id: @post.id)

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      @post = ViewerPost.find_by(post_numbering_id: params[:id])
      like = Like.find_by(user_id: current_user.id, viewer_post_id: @post.id)

    else
      flash[:notice] = "投稿が存在しません"
    end

    like.destroy
  end

  private

  def set_viewer
    @viewer = Viewer.find(params[:id])
  end

end
