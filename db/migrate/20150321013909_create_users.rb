class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string   "name"
	    t.string   "email"
	    t.string   "phone"
	    t.string   "apt_number"
	    t.string   "street"
	    t.string   "city"
	    t.string   "state"
	    t.string   "zip_code"
	    t.timestamps null: false
    end
  end
end
