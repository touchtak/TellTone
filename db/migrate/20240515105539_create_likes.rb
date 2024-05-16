class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :viewer_post_id
      t.integer :creator_post_id

      t.timestamps
    end
  end
end
