class ViewersController < ApplicationController
  before_action :current_viewer_existence_check, only: [:new, :create]
  before_action :viewer_existence_check, only: [:show, :edit]
  before_action :viewer_current_user_verification, only: [:edit, :update]

  # ビューワー情報登録ページ
  def new
    @viewer = Viewer.new
  end

  # ビューワー情報登録処理
  def create
    viewer = Viewer.new(viewer_params)
    viewer.user_id = current_user.id
    if viewer.save

      # 作製したビューワーのidをユーザー側に保存
      current_user.viewer_id = viewer.id
      current_user.update(viewer_id: viewer.id)

      flash[:notice] = "アカウントを作成しました。ようこそ！"
      redirect_to viewer_path(viewer)
    else
      @viewer = Viewer.new
      render :new
    end
  end

  # 各ビューワー詳細ページ
  def show
    @viewer = Viewer.find(params[:id])
    @followings = (@viewer.viewer_followings + @viewer.creator_followings)
    @post_data = ViewerPost.where(viewer_id: @viewer.id).sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@post_data).page(params[:page]).per(10)
  end

  def index
  end

  def edit
    @viewer = Viewer.where(user_id: current_user.id).first
  end

  def update
    viewer = Viewer.find(params[:id])
    if viewer.update(viewer_params)
      flash[:notice] = "変更しました"
      redirect_to viewer_path(current_user.viewer_id)
    else
      flash[:notice] = "変更に失敗しました"
      @viewer = viewer
      render :edit
    end
  end

  private

  def viewer_params
    params.require(:viewer).permit(:name, :introduction, :viewer_icon)
  end

  # ビューワー作成済みの時、新規作成ページへのアクセスを制限する
  def current_viewer_existence_check
    if current_user.viewer_id.present?
      flash[:notice] = "ビューワー情報は登録済みです"
      redirect_to viewer_path(current_user.viewer_id)
    end
  end

  # 閲覧しようとしたビューワーidが存在しない場合、詳細画面へのアクセスを制限する
  def viewer_existence_check
    unless Viewer.exists?(params[:id])
      flash[:notice] = "ビューワーが存在しません"
      redirect_to viewer_path(current_user.viewer_id)
    end
  end

  # 指定したビューワーidがログインしているユーザーの物でない場合、編集ページのアクセスを制限する
  def viewer_current_user_verification
    viewer = Viewer.find(params[:id])
    unless viewer.user_id == current_user.id
      flash[:notice] = "他のビューワーの情報は編集できません"
      redirect_to viewer_path(current_user.viewer_id)
    end
  end

end