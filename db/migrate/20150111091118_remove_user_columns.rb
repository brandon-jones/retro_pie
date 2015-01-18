class RemoveUserColumns < ActiveRecord::Migration
  def change
  	remove_column :users, :salt, :string
  	remove_column :users, :session_token, :string
  	remove_column :users, :session_token_expiration, :datetime
  end
end
