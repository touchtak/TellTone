class ViewersController < ApplicationController

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
  end

  def update
  end

  private

  def viewer_params
    params.require(:viewer).permit(:name, :introduction)
  end

end
