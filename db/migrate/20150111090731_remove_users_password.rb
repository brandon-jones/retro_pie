class RemoveUsersPassword < ActiveRecord::Migration
  def change
  	add_column :users, :texting_allowed, :boolean
  	remove_column :users, :password_digest, :string
  	add_column :users, :order_id, :string
  end
end
