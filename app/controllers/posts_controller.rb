class PostsController < ApplicationController
  before_action :viewer_existence_check
  before_action :creater_existence_check, only: [:creater_post_new, :creater_post_create]
  before_action :post_current_user_verification, only: [:destroy]

  # タイムライン
  def index
    # 自分の投稿
    current_viewer_posts = ViewerPost.where(viewer_id: current_user.viewer.id)
    if CreatorPost.find_by(user_id: current_user.id).present?
      current_creator_posts = CreatorPost.where(creator_id: current_user.creator.id)
      current_user_posts = (current_viewer_posts + current_creator_posts)
    else
      current_user_posts = current_viewer_posts
    end

    # フォローしているビューワー・クリエイターの投稿
    following_creator_posts = CreatorPost.where(creator_id: current_user.viewer.creator_followings)
    following_viewer_posts = ViewerPost.where(viewer_id: current_user.viewer.viewer_followings)

    @post_data = (current_user_posts + following_creator_posts + following_viewer_posts).sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@post_data).page(params[:page]).per(10)
  end

  # 投稿詳細
  def show
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      @post = CreatorPost.find_by(post_numbering_id: params[:id])
      @comment_data = Comment.where(creator_post_id: @post.id).sort_by(&:created_at).reverse

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      @post = ViewerPost.find_by(post_numbering_id: params[:id])
      @comment_data = Comment.where(viewer_post_id: @post.id).sort_by(&:created_at).reverse

    else
      flash[:notice] = "投稿が存在しません"
      redirect_back(fallback_location: root_path)
    end

    @comments = Kaminari.paginate_array(@comment_data).page(params[:page]).per(10)
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
      post_numbering.update(viewer_post_id: viewer_post.id)
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url]
    else
      post_numbering.delete
      @viewer_post = ViewerPost.new
      flash[:notice] = "投稿できませんでした"
      render :viewer_post_new
    end
  end

  # クリエイター投稿作成処理
  def creator_post_new
    @creator_post = CreatorPost.new

    # 投稿後に遷移する為、元のページのセッションを保存
    session[:previous_url] = request.referer
  end

  # クリエイター投稿作成処理
  def creator_post_create
    creator_post = CreatorPost.new(creator_post_params)
    creator_post.user_id = current_user.id
    creator_post.creator_id = current_user.creator.id

    # 投稿管理id作成
    post_numbering = PostNumbering.new
    post_numbering.save

    creator_post.post_numbering_id = post_numbering.id

    if creator_post.save
      post_numbering.update(creator_post_id: creator_post.id)
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url]
    else
      post_numbering.delete
      @creator_post = CreatorPost.new
      flash[:notice] = "投稿できませんでした"
      render :creater_post_new
    end
  end

  # 投稿削除処理
  def destroy
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      post = CreatorPost.find_by(post_numbering_id: params[:id])

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      post = ViewerPost.find_by(post_numbering_id: params[:id])

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
    params.require(:viewer_post).permit(:body, :post_image)
  end

  def creator_post_params
    params.require(:creator_post).permit(:body, :post_image)
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
    if CreatorPost.find_by(post_numbering_id: params[:id]).present?
      post = CreatorPost.find_by(post_numbering_id: params[:id])

    elsif ViewerPost.find_by(post_numbering_id: params[:id]).present?
      post = ViewerPost.find_by(post_numbering_id: params[:id])

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
