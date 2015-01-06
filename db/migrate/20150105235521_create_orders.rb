class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :item_id
      t.float :item_price
      t.integer :item_count
      t.string :status
      t.string :name
      t.string :email
      t.text :perferred_contact
      t.text :shipping_info
      t.string :delivery_type
      t.float :shipping_price
      t.string :order_id
      t.text :special_instructions

      t.timestamps
    end
  end
end
