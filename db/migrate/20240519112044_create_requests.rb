class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.integer :creator_id
      t.integer :viewer_id
      t.text :body

      t.timestamps
    end
  end
end
