class RemoveDeliveryTypeFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :delivery_type, :string
  end
end
