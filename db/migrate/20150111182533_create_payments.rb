class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.float :ammount

      t.timestamps
    end
  end
end
