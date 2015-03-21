class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
    	t.integer  "order_id"
	    t.monetize  "amount"
	    t.string   "status"
	    t.text     "meta"
	    t.timestamps null: false
    end
  end
end
