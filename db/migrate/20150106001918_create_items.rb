class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.string :amazon_url
      t.string :image_url
      t.float :price
      t.boolean :base_item
      t.integer :category_id

      t.timestamps
    end
  end
end
