class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
    	t.integer  "item_id"
	    t.integer  "quantity"
	    t.monetize "item_price"
	    t.monetize "item_cost"
	    t.integer  "order_id"
	    t.datetime "created_at"
	    t.timestamps null: false
    end
  end
end
