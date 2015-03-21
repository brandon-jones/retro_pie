class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.boolean  "update_unlockd", default: false
    	t.string   "title"
	    t.boolean  "title_locked"
	    t.string   "title_css"
	    t.text     "description"
	    t.boolean  "description_locked"
	    t.string   "description_css"
	    t.string   "amazon_url"
	    t.string   "image_url"
	    t.boolean  "image_url_locked"
	    t.string   "image_url_css"
	    t.monetize "cost"
	    t.string   "cost_css"
	    t.boolean  "base_item"
	    t.integer  "category_id"
	    t.string   "markup"
	    t.timestamps null: false
    end
  end
end
