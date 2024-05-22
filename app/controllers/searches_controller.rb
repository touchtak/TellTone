class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "クリエイター"
      creators = Creator.looks(params[:search], params[:word])
      @creators = Kaminari.paginate_array(creators).page(params[:page]).per(10)
      render 'creators/index'
    elsif @range == "ビューワー"
      viewers = Viewer.looks(params[:search], params[:word])
      @viewers = Kaminari.paginate_array(viewers).page(params[:page]).per(10)
      render 'viewers/index'
    elsif @range == "作品"
      posts = CreatorPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
      render 'posts/index'
    else
      posts = ViewerPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
      render 'posts/index'
    end
  end

end
