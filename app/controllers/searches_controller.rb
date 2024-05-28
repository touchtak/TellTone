class SearchesController < ApplicationController
  before_action :current_viewer_existence_before_check

  # ユーザー検索
  def search_form
  end

  # 投稿検索
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
      posts = CreatorPost.looks(params[:search], params[:word])

      # 並べ替え
      sequence = params[:sequence]
      if sequence == "新着"
        posts_data = posts.sort_by(&:created_at).reverse
      elsif sequence == "人気"
        posts_data = posts.sort_by { |post| -post.like_count(post) }
      else
        posts_data = posts.shuffle
      end

      # 画像作品
      works_data = posts_data.select { |work| work.post_image.attached? || work.audio.present? }
      @posts = Kaminari.paginate_array(works_data).page(params[:page]).per(10)
      # 音声作品
      @audio_works_data = posts_data.select { |work| work.audio.present? }
      @audio_work = @audio_works_data[0]
      @current_index = 0

      render 'posts/index'

    else
      posts = ViewerPost.looks(params[:search], params[:word])

      # 音声作品
      creator_posts = CreatorPost.looks(params[:search], params[:word])
      audios = creator_posts.select { |work| work.audio.present? }

      # 並べ替え
      sequence = params[:sequence]
      if sequence == "新着"
        posts_data = posts.sort_by(&:created_at).reverse
        audios_data = audios.sort_by(&:created_at).reverse
      elsif sequence == "人気"
        posts_data = posts.sort_by { |post| -post.like_count(post) }
        audios_data = audios.sort_by { |post| -post.like_count(post) }
      else
        posts_data = posts.shuffle
        audios_data = audios.shuffle
      end

      @posts = Kaminari.paginate_array(posts_data).page(params[:page]).per(10)

      @audio_works_data = audios_data
      @audio_work = @audio_works_data[0]
      @current_index = 0
      render 'posts/index'
    end
  end

  # タグ検索
  def tag_search_form
  end

  def tag_search
    post_tags = PostTag.looks(params[:search], params[:word])

    posts = []
    range = params[:range]
    if range == "作品"
      post_tags.each do |tag|
        if tag.creator_posts.exists?
          posts += tag.creator_posts.to_a
        else
        end
      end
    else
      post_tags.each do |tag|
        if tag.viewer_posts.exists?
          posts += tag.viewer_posts.to_a
        else
        end
      end
    end

    sequence = params[:sequence]
    if sequence == "新着"
      posts_data = posts.sort_by { |post| post.created_at }.reverse
    elsif sequence == "人気"
      posts_data = posts.sort_by { |post| -post.like_count(post) }
    else
      posts_data = posts.shuffle
    end

    # 画像作品
    works_data = posts_data.select { |work| work.respond_to?(:creator_id) && work.post_image.attached? || work.respond_to?(:creator_id) && work.audio.present? }
    @posts = Kaminari.paginate_array(works_data).page(params[:page]).per(10)
    # 音声作品
    @audio_works_data = posts_data.select { |work| work.respond_to?(:creator_id) && work.audio.present? }
    @audio_work = @audio_works_data[0]
    @current_index = 0
    render 'posts/index'
  end

  # イメージ検索
  def emotion_search_form
  end

  def emotion_search
    creator_posts = CreatorPost.where(emotion_id: params[:emotion_id])

    sequence = params[:sequence]
    if sequence == "新着"
      posts_data = creator_posts.sort_by { |post| post.created_at }.reverse
    elsif sequence == "人気"
      posts_data = creator_posts.sort_by { |post| -post.like_count(post) }
    else
      posts_data = creator_posts.shuffle
    end

    # 画像作品
    works_data = posts_data.select { |work| work.respond_to?(:creator_id) && work.post_image.attached? || work.respond_to?(:creator_id) && work.audio.present? }
    @posts = Kaminari.paginate_array(works_data).page(params[:page]).per(10)
    # 音声作品
    @audio_works_data = posts_data.select { |work| work.respond_to?(:creator_id) && work.audio.present? }
    @audio_work = @audio_works_data[0]
    @current_index = 0
    render 'posts/index'
  end

end
