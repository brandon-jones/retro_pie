class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
      t.string :apt_number
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.integer :order_id

      t.timestamps
    end
  end
end
