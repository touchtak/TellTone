class CreateCreaterPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :creater_posts do |t|
      t.integer :user_id
      t.integer :creater_id
      t.integer :tag_id
      t.integer :emotion_id
      t.integer :post_numbering_id
      t.text :audio
      t.text :body, null: false, default: ""

      t.timestamps
    end
  end
end
