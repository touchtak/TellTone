class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      comment.user_id = current_user.id
      comment.viewer_id = current_user.viewer.id
      
    else
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
