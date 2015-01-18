class AddSessionTokenExpirationToUser < ActiveRecord::Migration
  def change
    add_column :users, :session_token_expiration, :datetime
  end
end
