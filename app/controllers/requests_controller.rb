class RequestsController < ApplicationController

  def index
    @requests = Request.find_by(creator_id: params[:id])
  end

  def new
    @request = Request.new

    # 投稿後に遷移する為、元のページのセッションを保存
    session[:previous_url] = request.referer
  end

  def create
    request = Request.new(request_params)
    request.creator_id = Creator(params[:id])
    request.viewer_id = current_user.viewer.id

    if request.save
      flash[:notice] = "リクエストを投稿しました"
    else
      flash[:notice] = "投稿に失敗しました"
      redirect_back(fallback_location: root_path)
    end

    redirect_to session[:previous_url]
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
      flash[:notice] = "変更に失敗しました"
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
    params.require(:request).permit(:body, :request_image)
  end

end
