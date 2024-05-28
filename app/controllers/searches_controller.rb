class SearchesController < ApplicationController

  def search_form
  end

  def post_search_form
  end

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
      sequence = params[:sequence]
      if sequence == "新着"
        posts = CreatorPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      elsif sequence == "人気"
        creator_posts = CreatorPost.looks(params[:search], params[:word])
        posts = creator_posts.sort_by{ |post| -post.like_count(post) }
      else
        creator_posts = CreatorPost.looks(params[:search], params[:word])
        posts = creator_posts.shuffle
      end
      posts_data = posts.select{ |post| post.post_image.attached? }
      @posts = Kaminari.paginate_array(posts_data).page(params[:page]).per(10)
      render 'posts/index'

    else
      sequence = params[:sequence]
      if sequence == "新着"
        posts = ViewerPost.looks(params[:search], params[:word]).sort_by(&:created_at).reverse
      elsif sequence == "人気"
        viewer_posts = ViewerPost.looks(params[:search], params[:word])
        posts = viewer_posts.sort_by{ |post| -post.like_count(post) }
      else
        viewer_posts = ViewerPost.looks(params[:search], params[:word])
        posts = viewer_posts.shuffle
      end
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
      render 'posts/index'
    end
  end

  def tag_search_form
  end

  def tag_search
    searched_tags = PostTag.looks(params[:search], params[:word])

    range = params[:range]
    posts = []
    creator_posts = []
    if range == "作品"
      searched_tags.each do |tag|
        if tag.creator_posts.exists?
          creator_posts += tag.creator_posts
        end
      end
      posts = creator_posts.select{ |post| post.post_image.attached? }

    else
      searched_tags.each do |tag|
        if tag.viewer_posts.present?
          posts += tag.viewer_posts
        end
      end
    end

    sequence = params[:sequence]
    if sequence == "新着"
      posts_data = posts.sort_by(&:created_at).reverse
    elsif sequence == "人気"
      posts_data = posts.sort_by{ |post| -post.like_count(post) }
    else
      posts_data = posts.shuffle
    end

    @posts = Kaminari.paginate_array(posts_data).page(params[:page]).per(10)
    render 'posts/index'
  end

  def emotion_search_form
  end

  def emotion_search
    creator_posts = CreatorPost.where(emotion_id: params[:emotion_id])

    sequence = params[:sequence]
    if sequence == "新着"
      posts = creator_posts.sort_by(&:created_at).reverse
    elsif sequence == "人気"
      posts = creator_posts.sort_by{ |post| -post.like_count(post) }
    else
      posts = creator_posts.shuffle
    end

    posts_data = posts.select{ |post| post.post_image.attached? }
    @posts = Kaminari.paginate_array(posts_data).page(params[:page]).per(10)
    render 'posts/index'
  end

end
