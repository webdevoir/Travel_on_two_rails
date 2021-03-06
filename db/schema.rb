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

ActiveRecord::Schema.define(version: 20180823032526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "claps", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "donation_goals", force: :cascade do |t|
    t.float    "amount"
    t.integer  "trip_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "current_paid", default: 0.0
    t.string   "title"
    t.text     "description"
    t.date     "end_date"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "email"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followed_blogs", force: :cascade do |t|
    t.integer  "blog_owner_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "gear_lists", force: :cascade do |t|
    t.integer  "trip_id"
    t.string   "bike"
    t.string   "tent"
    t.string   "pannier"
    t.text     "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text    "body"
    t.integer "conversation_id"
    t.integer "user_id"
    t.boolean "read",            default: false
    t.boolean "flagged",         default: false
    t.boolean "open_offense",    default: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "point_of_interests", force: :cascade do |t|
    t.integer  "route_id"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.text     "info"
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
    t.string   "center_lat"
    t.string   "center_lng"
    t.text     "poly_line"
    t.string   "address1_lat"
    t.string   "address1_lng"
    t.string   "address2_lat"
    t.string   "address2_lng"
    t.integer  "route_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "buyer_id"
    t.integer  "donation_goal_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "paid",             default: false
    t.string   "stripe_charge"
  end

  create_table "routes", force: :cascade do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "center_lat"
    t.string   "center_lng"
    t.text     "poly_line"
    t.string   "address1_lat"
    t.string   "address1_lng"
    t.string   "address2_lat"
    t.string   "address2_lng"
    t.boolean  "public"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "distance"
  end

  create_table "saved_routes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stripe_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "access_code"
    t.string   "publishable_key"
    t.string   "uid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "stripe_customer_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string   "trip_name"
    t.integer  "user_id"
    t.string   "photo"
    t.integer  "total_distance", default: 0
    t.text     "description"
    t.string   "start"
    t.string   "end"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
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
    t.boolean  "verified",               default: false
    t.boolean  "email_subscribe",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.integer  "offense_count",          default: 0
    t.boolean  "banned",                 default: false
    t.datetime "terms_accepted_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.integer  "expires_at"
    t.boolean  "expires"
    t.string   "refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
