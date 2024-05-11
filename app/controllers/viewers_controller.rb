class ViewersController < ApplicationController
  before_action :current_viewer_existence_check, only: [:new, :create]
  before_action :viewer_existence_check, only: [:show]
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
    @posts = ViewerPost.where(viewer_id: @viewer.id)
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
      redirect_to viewer_path()
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

  # 指定したビューワーidがログインしているユーザーの物でない場合、編集ページのアクセスを制限する
  def viewer_current_user_verification
    viewer = Viewer.find(params[:id])
    unless viewer.user_id == current_user.id
      @viewer = Viewer.find(current_user.viewer_id)
      @posts = ViewerPost.where(viewer_id: @viewer.id)
      render :show
    end
  end

end
