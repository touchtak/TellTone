class CommentsController < ApplicationController

  def new
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      @post = CreatorPost.find_by(post_numbering_id: params[:id])
      @comment = Comment.new

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      @post = ViewerPost.find_by(post_numbering_id: params[:id])
      @comment = Comment.new

    else
      flash[:notice] = "投稿が存在しません"
      redirect_back(fallback_location: root_path)
    end

    session[:previous_url] = request.referer
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.viewer_id = current_user.viewer.id

    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      post = CreatorPost.find_by(post_numbering_id: params[:id])
      @comment.creator_post_id = post.id
    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      post = ViewerPost.find_by(post_numbering_id: params[:id])
      @comment.viewer_post_id = post.id
    end

    if @comment.save
      flash[:notice] = "コメントしました"
      redirect_to session[:previous_url]
    else
      @post = post
      flash.now[:notice] = "投稿できませんでした"
      render :new
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.destroy
      flash[:notice] = "削除しました"
    else
      flash[:notice] = "削除に失敗しました"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_image)
  end

end
