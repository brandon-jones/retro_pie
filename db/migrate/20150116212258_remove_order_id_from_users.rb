class RemoveOrderIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :order_id, :integer
  end
end
