class LikesController < ApplicationController

  def create
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      post = CreatorPost.find_by(post_numbering_id: params[:id])
      like = Like.new(user_id: current_user.id, creator_post_id: post.id)
      like.save
      redirect_back(fallback_location: root_path)

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      post = ViewerPost.find_by(post_numbering_id: params[:id])
      like = Like.new(user_id: current_user.id, viewer_post_id: post.id)
      like.save
      redirect_back(fallback_location: root_path)

    else
      flash[:notice] = "投稿が存在しません"
      redirect_back(fallback_location: root_path)
    end


  end

  def destroy
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      post = CreatorPost.find_by(post_numbering_id: params[:id])
      like = Like.find_by(user_id: current_user.id, creator_post_id: post.id)

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      post = ViewerPost.find_by(post_numbering_id: params[:id])
      like = Like.find_by(user_id: current_user.id, viewer_post_id: post.id)

    else
      flash[:notice] = "投稿が存在しません"
      redirect_back(fallback_location: root_path)
    end

    like.destroy
    redirect_back(fallback_location: root_path)
  end

end
