class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status_id
      t.string :name
      t.string :email
      t.text :perferred_contact
      t.text :shipping_info
      t.string :delivery_type
      t.float :shipping_price
      t.string :order_id
      t.text :special_instructions
      t.float :total

      t.timestamps
    end
  end
end
