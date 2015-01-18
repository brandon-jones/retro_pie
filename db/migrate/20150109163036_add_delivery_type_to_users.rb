class AddDeliveryTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delivery_type, :string
  end
end
