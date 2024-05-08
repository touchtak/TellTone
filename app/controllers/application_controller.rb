class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:top]

  # ビューワーの設定が未完了時に作成ページへ遷移
  # before_action :check_viewer, except: [:top, :users]


  def after_sign_in_path_for(resource)
      posts_path
  end

  # def check_viewer
  #   if current_user.viewer_id.nil?
  #     redirect_to new_viewer_path
  #   end
  # end

end
