class CreatorsController < ApplicationController
  before_action :current_creator_existence_check, only: [:new, :create]
  before_action :creator_existence_check, only: [:show, :edit]
  before_action :creator_current_user_verification, only: [:edit, :update]

  # クリエイター情報登録ページ
  def new
    @creator = Creator.new
  end

  # クリエイター情報登録処理
  def create
    creator = Creator.new(creator_params)
    creator.user_id = current_user.id
    if creator.save

      # 作製したクリエイターのidをユーザー側に保存
      current_user.creator_id = creator.id
      current_user.update(creator_id: creator.id)

      flash[:notice] = "アカウントを作成しました。ようこそ！"
      redirect_to creator_path(creator)
    else
      @creator = Creator.new
      render :new
    end
  end

  # 各クリエイター詳細ページ
  def show
    @creator = Creator.find(params[:id])
    @post_data = CreatorPost.where(creator_id: @creator.id).sort_by(&:created_at).reverse
    @posts = Kaminari.paginate_array(@post_data).page(params[:page]).per(10)
  end

  def index
  end

  def edit
    @creator = Creator.where(user_id: current_user.id).first
  end

  def update
    creator = Creator.find(params[:id])
    if creator.update(creator_params)
      flash[:notice] = "変更しました"
      redirect_to creator_path(creator.id)
    else
      flash[:notice] = "変更に失敗しました"
      @creator = creator
      render :edit
    end
  end

  private

  def creator_params
    params.require(:creator).permit(:name, :introduction, :creator_icon)
  end

  # クリエイター作成済みの時、新規作成ページへのアクセスを制限する
  def current_creator_existence_check
    if current_user.creator_id.present?
      flash[:notice] = "クリエイター情報は登録済みです"
      redirect_to creator_path(current_user.creator_id)
    end
  end

  # 閲覧しようとしたクリエイターidが存在しない場合、詳細画面へのアクセスを制限する
  def creator_existence_check
    unless Creator.exists?(params[:id])
      flash[:notice] = "クリエイターが存在しません"
      redirect_to creator_path(current_user.creator_id)
    end
  end

  # 指定したクリエイターidがログインしているユーザーの物でない場合、編集ページのアクセスを制限する
  def creator_current_user_verification
    creator = Creator.find(params[:id])
    unless creator.user_id == current_user.id
      flash[:notice] = "他のクリエイターの情報は編集できません"
      redirect_to creator_path(current_user.creator_id)
    end
  end

end
