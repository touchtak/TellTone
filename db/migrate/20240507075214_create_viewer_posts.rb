class CreateViewerPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :viewer_posts do |t|
      t.integer :user_id
      t.integer :viewer_id
      t.integer :tag_id
      t.integer :post_numbering_id
      t.text :body, null: false

      t.timestamps
    end
  end
end
