class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "クリエイター"
      @creators = Creator.looks(params[:search], params[:word])
      render 'creators/index'
    elsif @range == "ビューワー"
      @viewers = Viewer.looks(params[:search], params[:word])
      render 'viewers/index'
    elsif @range == "作品"
      @posts = CreatorPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      render 'posts/index'
    else
      @posts = ViewerPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      render 'posts/index'
    end
  end

end
