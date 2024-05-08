class CreatePostNumberings < ActiveRecord::Migration[6.1]
  def change
    create_table :post_numberings do |t|

      t.timestamps
    end
  end
end
