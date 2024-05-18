class RelationshipsController < ApplicationController

  # フォロー時の処理
  def creator_relation_create
    creator_relationship = CreatorRelationship.new
    creator_relationship.follower_id = current_user.viewer.id
    creator_relationship.followed_id = Creator.find(params[:id]).id
    creator_relationship.save
    redirect_to request.referer
  end

  def viewer_relation_create
    @viewer = Viewer.find(params[:id])
    viewer_relationship = ViewerRelationship.new
    viewer_relationship.follower_id = current_user.viewer.id
    viewer_relationship.followed_id = @viewer.id
    viewer_relationship.save

    # 非同期通信用
    @followings = (@viewer.viewer_followings + @viewer.creator_followings)
  end

  # フォロー解除時の処理
  def creator_relation_destroy
    creator_relationship = CreatorRelationship.find_by(follower_id: current_user.viewer.id, followed_id: params[:id])
    creator_relationship.destroy
    redirect_to request.referer
  end

  def viewer_relation_destroy
    viewer_relationship = ViewerRelationship.find_by(follower_id: current_user.viewer.id, followed_id: params[:id])
    viewer_relationship.destroy

    # 非同期通信用
    @viewer = Viewer.find(params[:id])
    @followings = (@viewer.viewer_followings + @viewer.creator_followings)
  end

  # 一覧表示
  def followings
  end

  def followers
  end

end
