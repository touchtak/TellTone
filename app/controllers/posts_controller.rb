class PostsController < ApplicationController
  before_action :current_viewer_existence_before_check
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

    # 再生用音声作品
    # if following_creator_posts.present? && current_creator_posts.present?
    #   creator_posts = (current_creator_posts + following_creator_posts)
    #   audio_works = creator_posts.select { |work| work.audio.present? }
    #   @audio_works_data = audio_works.sort_by(&:created_at).reverse
    #   @audio_work = @audio_works_data[0]
    #   @current_index = 0

    # elsif following_creator_posts.present?
    #   creator_posts = following_creator_posts
    #   audio_works = creator_posts.select { |work| work.audio.present? }
    #   @audio_works_data = audio_works.sort_by(&:created_at).reverse
    #   @audio_work = @audio_works_data[0]
    #   @current_index = 0

    # elsif current_creator_posts.present?
    #   creator_posts = current_creator_posts
    #   audio_works = creator_posts.select { |work| work.audio.present? }
    #   @audio_works_data = audio_works.sort_by(&:created_at).reverse
    #   @audio_work = @audio_works_data[0]
    #   @current_index = 0
    # else
    # end
    if following_creator_posts.present? && current_creator_posts.present?
      @post_data = (current_user_posts + following_creator_posts + following_viewer_posts).sort_by(&:created_at).reverse
    elsif following_creator_posts.present?
      @post_data = (current_user_posts + following_creator_posts).sort_by(&:created_at).reverse
    elsif current_creator_posts.present?
      @post_data = (current_user_posts + following_viewer_posts).sort_by(&:created_at).reverse
    else
      @post_data = current_user_posts.sort_by(&:created_at).reverse
    end
    @posts = Kaminari.paginate_array(@post_data).page(params[:page]).per(10)
  end

  # 音声再生機能用
  # def previous
  #   @audio_works_data = params[:works]
  #   @current_index = params[:current_index].to_i - 1
  #   if @audio_works_data[@current_index.to_i].present?
  #     @audio_work = CreatorPost.find(@audio_works_data[@current_index.to_i])
  #   else
  #     @current_index = -1
  #     @audio_work = CreatorPost.find(@audio_works_data[@current_index.to_i])
  #   end
  # end

  # def next
  #   @audio_works_data = params[:works]
  #   @current_index = params[:current_index].to_i + 1
  #   if @audio_works_data[@current_index.to_i].present?
  #     @audio_work = CreatorPost.find(@audio_works_data[@current_index.to_i])
  #   else
  #     @current_index = 0
  #     @audio_work = CreatorPost.find(@audio_works_data[@current_index.to_i])
  #   end
  # end

  # 投稿作品一覧
  def work_index
    @creator = Creator.find(params[:id])
    creator_posts = CreatorPost.where(creator_id: @creator.id)
    works = creator_posts.select { |creator_post| creator_post.post_image.attached? || creator_post.audio.present? }

    @work_data = works.sort_by(&:created_at).reverse
    @works = Kaminari.paginate_array(@work_data).page(params[:page]).per(10)
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
    @tag_list = @viewer_post.post_tags.pluck(:name).join(',')

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

    tag_list = params[:viewer_post][:name].split(',')
    if viewer_post.save
      post_numbering.update(viewer_post_id: viewer_post.id)
      viewer_post.save_post_tags(tag_list)
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url] || root_path
    else
      post_numbering.delete
      @viewer_post = viewer_post
      flash.now[:notice] = "投稿できませんでした"
      render :viewer_post_new || root_path
    end
  end

  # クリエイター投稿作成処理
  def creator_post_new
    @creator_post = CreatorPost.new
    @tag_list = @creator_post.post_tags.pluck(:name).join(',')

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

    tag_list = params[:creator_post][:name].split(',')
    if creator_post.save
      post_numbering.update(creator_post_id: creator_post.id)
      creator_post.save_post_tags(tag_list)
      flash[:notice] = "投稿しました"
      redirect_to session[:previous_url] || root_path
    else
      post_numbering.delete
      @creator_post = creator_post
      flash.now[:notice] = "投稿できませんでした"
      render :creator_post_new || root_path
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
    params.require(:creator_post).permit(:body, :post_image, :audio, :emotion_id)
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
