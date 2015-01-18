class RemoveTextingAllowedFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :texting_allowed, :boolean
  end
end
