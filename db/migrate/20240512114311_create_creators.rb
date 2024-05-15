class CreateCreators < ActiveRecord::Migration[6.1]
  def change
    create_table :creators do |t|
      t.integer :user_id
      t.text :introduction
      t.string :name

      t.timestamps
    end
  end
end
