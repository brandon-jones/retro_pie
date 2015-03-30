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

ActiveRecord::Schema.define(version: 20150321013909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.boolean  "update_unlockd",     default: false
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
    t.integer  "cost_cents",         default: 0,     null: false
    t.string   "cost_currency",      default: "USD", null: false
    t.string   "cost_css"
    t.boolean  "base_item"
    t.integer  "category_id"
    t.string   "markup"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.integer  "cost_cents",     default: 0,     null: false
    t.string   "cost_currency",  default: "USD", null: false
    t.integer  "order_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "status_id"
    t.integer  "shipping_price_cents",    default: 0,     null: false
    t.string   "shipping_price_currency", default: "USD", null: false
    t.string   "order_id"
    t.text     "special_instructions"
    t.integer  "total_cents",             default: 0,     null: false
    t.string   "total_currency",          default: "USD", null: false
    t.integer  "cost_cents",              default: 0,     null: false
    t.string   "cost_currency",           default: "USD", null: false
    t.string   "delivery_type"
    t.integer  "user_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.string   "status"
    t.text     "meta"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
