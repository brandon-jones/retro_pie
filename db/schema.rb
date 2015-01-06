# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150106001918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "amazon_url"
    t.string   "image_url"
    t.float    "price"
    t.boolean  "base_item"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "item_id"
    t.float    "item_price"
    t.integer  "item_count"
    t.string   "status"
    t.string   "name"
    t.string   "email"
    t.text     "perferred_contact"
    t.text     "shipping_info"
    t.string   "delivery_type"
    t.float    "shipping_price"
    t.string   "order_id"
    t.text     "special_instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
