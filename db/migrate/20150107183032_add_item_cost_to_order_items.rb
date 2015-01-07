class AddItemCostToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :item_cost, :float
  end
end
