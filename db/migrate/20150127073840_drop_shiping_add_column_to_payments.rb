class DropShipingAddColumnToPayments < ActiveRecord::Migration
  def change
  	drop_table :shippings
  	add_column :payments, :meta, :text 
  end
end
