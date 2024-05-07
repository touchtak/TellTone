class PostsController < ApplicationController

  def index
  end

  def show
  end

  # ビューワー投稿作成画面
  def viewer_post_new
    @viewer_post = ViewerPost.new

    # 投稿後に遷移する為、元のページのセッションを保存
    session[:previous_url] = request.referer
  end

  # ビューワー投稿作成処理
  def viewer_post_create

    viewer_post = ViewerPost.new(viewer_post_params)
    viewer_post.user_id = current_user.id
    viewer_post.viewer_id = current_user.viewer.id

    # 投稿管理id作成
    post_numbering = PostNumbering.new
    post_numbering.save

    viewer_post.post_numbering_id = post_numbering.id

    if viewer_post.save
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url]
    else
      post_numbering.delete
      @viewer_post = viewer_post
      render :viewer_post_new
    end
  end

  # クリエイター投稿作成処理
  def creater_post_new
    @creater_post = CreaterPost.new

    # 投稿後に遷移する為、元のページのセッションを保存
    session[:previous_url] = request.referer
  end

  # クリエイター投稿作成処理
  def creater_post_create

    # 投稿管理id作成
    post_numbering = PostNumbering.new
    if post_numbering.save
      creater_post = CreaterPost.new(creater_post_params)
      creater_post.post_numbering_id = post_numbering.id
    else
      @creater_post = CreaterPost.new
      render :creater_post_new
    end

    # クリエイター投稿作成
    if viewer_post.save
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url]
    else
      post_numbering.delete
      @creater_post = CreaterPost.new
      redirect :creater_post_new
    end
  end

  private

  def viewer_post_params
    params.require(:viewer_post).permit(:body)
  end
end
