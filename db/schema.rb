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

ActiveRecord::Schema.define(version: 20170701042853) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "donation_goals", force: :cascade do |t|
    t.float    "amount"
    t.integer  "trip_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "current_paid", default: 0.0
  end

  create_table "post_groups", force: :cascade do |t|
    t.string   "month"
    t.string   "year"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "trip_id"
  end

  create_table "post_pictures", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "post_title"
    t.string   "post_content"
    t.string   "address1"
    t.string   "address2"
    t.integer  "trip_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "post_group_id"
    t.string   "day"
    t.integer  "distance"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "buyer_id"
    t.integer  "donation_goal_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "trips", force: :cascade do |t|
    t.string  "trip_name"
    t.integer "user_id"
    t.string  "photo"
    t.integer "total_distance", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "cover"
    t.string   "avatar"
    t.string   "name"
    t.text     "description"
    t.string   "country"
    t.string   "province"
    t.string   "city"
    t.integer  "braintree_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
