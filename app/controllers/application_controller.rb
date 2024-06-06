class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:top]

  def after_sign_in_path_for(resource)
      posts_path
  end

  # ビューワー未作成の時、各ページへのアクセスを制限する
  def current_viewer_existence_before_check
    unless current_user.viewer_id.present?
      flash[:notice] = "ビューワー情報が未登録です"
      redirect_to new_viewer_path
    end
  end

end
