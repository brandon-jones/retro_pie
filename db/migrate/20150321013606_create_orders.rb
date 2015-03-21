class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string   "status_id"
	    t.monetize  "shipping_price"
	    t.string   "order_id"
	    t.text     "special_instructions"
	    t.monetize  "total"
	    t.monetize  "cost"
	    t.string   "delivery_type"
	    t.integer  "user_id"
	    t.timestamps null: false
    end
  end
end
