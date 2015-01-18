class RemoveDeliveryTypeFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :delivery_type, :string
  end
end
