class RemoveLotsFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :name, :string
    remove_column :orders, :email, :string
    remove_column :orders, :perferred_contact, :text
    remove_column :orders, :shipping_info, :text
  end
end
