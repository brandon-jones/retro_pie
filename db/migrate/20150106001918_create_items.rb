class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.boolean :title_locked
      t.string :title_css
      t.text :description
      t.boolean :description_locked
      t.string :description_css
      t.string :amazon_url
      t.string :image_url
      t.boolean :image_url_locked
      t.string :image_url_css
      t.float :price
      t.string :price_css
      t.boolean :base_item
      t.integer :category_id
      t.string :markup
      t.timestamps
    end
  end
end