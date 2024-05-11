class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:top]

  def after_sign_in_path_for(resource)
      posts_path
  end

  # ビューワー作成済みの時、新規作成ページへのアクセスを制限する
  def viewer_existence_check
    if current_user.viewer_id.present?
      redirect_to viewer_path(current_user.viewer_id)
    end
  end

end
