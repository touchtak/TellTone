class PostsController < ApplicationController
  before_action :viewer_existence_check
  before_action :creater_existence_check, only: [:creater_post_new, :creater_post_create]
  before_action :post_current_user_verification, only: [:destroy]

  def index
  end

  # 投稿詳細
  def show
    if CreaterPost.where(post_numbering_id: params[:id]).first.present?
      @post = CreaterPost.where(post_numbering_id: params[:id]).first

    elsif ViewerPost.where(post_numbering_id: params[:id]).first.present?
      @post = ViewerPost.where(post_numbering_id: params[:id]).first

    else
      flash[:notice] = "投稿が存在しません"
    end
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
      @viewer_post = ViewerPost.new
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
    creater_post = CreaterPost.new(creater_post_params)
    creater_post.user_id = current_user.id
    creater_post.viewer_id = current_user.creater.id

    # 投稿管理id作成
    post_numbering = PostNumbering.new
    post_numbering.save

    creater_post.post_numbering_id = post_numbering.id

    if creater_post.save
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url]
    else
      post_numbering.delete
      @creater_post = CreaterPost.new
      render :creater_post_new
    end
  end

  # 投稿削除処理
  def destroy
    if CreaterPost.where(post_numbering_id: params[:id]).first.present?
      post = CreaterPost.where(post_numbering_id: params[:id]).first

    elsif ViewerPost.where(post_numbering_id: params[:id]).first.present?
      post = ViewerPost.where(post_numbering_id: params[:id]).first

    else
      flash[:notice] = "投稿が存在しません"
    end

    if post.destroy
      flash[:notice] = "削除しました"
    else
      flash[:notice] = "削除に失敗しました"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def viewer_post_params
    params.require(:viewer_post).permit(:body)
  end

  # ビューワー未作成の時、ページへのアクセスを制限する
  def viewer_existence_check
    unless current_user.viewer_id.present?
      redirect_to new_viewer_path
    end
  end

  # クリエイター未作成の時、ページへのアクセスを制限する
  def creater_existence_check
    unless current_user.creater_id.present?
      redirect_to new_creater_path
    end
  end

  # 指定した投稿がログインしているユーザーの物でない場合、削除処理を制限する
  def post_current_user_verification
    if CreaterPost.where(post_numbering_id: params[:id]).first.present?
      post = CreaterPost.where(post_numbering_id: params[:id]).first

    elsif ViewerPost.where(post_numbering_id: params[:id]).first.present?
      post = ViewerPost.where(post_numbering_id: params[:id]).first

    else
      flash[:notice] = "投稿が存在しません"
      redirect_back(fallback_location: root_path)
    end

    unless post.user_id == current_user.id
      flash[:notice] = "他のユーザーの投稿は削除できません"
      redirect_back(fallback_location: root_path)
    end
  end
end