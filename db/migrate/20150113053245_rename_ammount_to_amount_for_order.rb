class RenameAmountToAmountForOrder < ActiveRecord::Migration
  def change
  	rename_column :payments, :amount, :amount
  end
end
