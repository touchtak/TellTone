class RequestsController < ApplicationController
  before_action :current_viewer_existence_before_check
  before_action :creator_existence_check, only: [:index, :new]

  def index
    requests = Request.where(creator_id: params[:id]).sort_by(&:created_at).reverse
    @requests = Kaminari.paginate_array(requests).page(params[:page]).per(10)
    @creator = Creator.find(params[:id])
  end

  def new
    @request = Request.new
    @creator = Creator.find(params[:id])
  end

  def create
    request = Request.new(request_params)
    request.creator_id = Creator.find(params[:id]).id
    request.viewer_id = current_user.viewer.id

    if request.save
      flash[:notice] = "リクエストを投稿しました"
      redirect_to requests_path(request.creator_id)
    else
      @request = request
      @creator = Creator.find(params[:id])
      flash.now[:notice] = "投稿に失敗しました"
      render :new || root_path
    end
  end

  def edit
    @request = Request.find(params[:id])

    # 投稿後に遷移する為、元のページのセッションを保存
    session[:previous_url] = request.referer
  end

  def update
    request = Request.find(params[:id])
    if request.update(request_params)
      flash[:notice] = "変更しました"
      redirect_to requests_path(request.creator_id)
    else
      flash.now[:notice] = "変更に失敗しました"
      @request = request
      render :edit
    end
  end

  def destroy
    request = Request.find(params[:id])

    if request.destroy
      flash[:notice] = "削除しました"
    else
      flash[:notice] = "削除に失敗しました"
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def request_params
    params.require(:request).permit(:body)
  end

  def creator_existence_check
    creator = Creator.find_by(id: params[:id])
    unless creator.present?
      flash[:notice] = "クリエイターが存在しません"
      redirect_back(fallback_location: root_path)
    end
  end

end
