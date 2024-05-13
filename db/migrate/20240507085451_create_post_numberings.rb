class CreatePostNumberings < ActiveRecord::Migration[6.1]
  def change
    create_table :post_numberings do |t|
      t.integer :viewer_post_id
      t.integer :creator_post_id

      t.timestamps
    end
  end
end
