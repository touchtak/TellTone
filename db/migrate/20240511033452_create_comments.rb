class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :viewer_id
      t.integer :viewer_post_id
      t.integer :creator_post_id
      t.text :comment

      t.timestamps
    end
  end
end
