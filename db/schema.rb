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

ActiveRecord::Schema.define(version: 20141211044335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "adventure_gallery_images", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "adventure_id"
  end

  create_table "adventures", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "slug"
    t.string   "location"
    t.text     "summary"
    t.integer  "cap_min"
    t.integer  "cap_max"
    t.integer  "price"
    t.string   "price_type"
    t.integer  "duration_num"
    t.string   "duration_type"
    t.string   "category"
    t.text     "other_notes"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "published"
    t.boolean  "approved"
    t.string   "city"
    t.string   "state"
    t.string   "region"
    t.string   "rating",                    default: ""
    t.string   "country"
    t.string   "video_url"
    t.boolean  "sent_approval_email",       default: false
    t.text     "attachment_meta"
    t.integer  "waiver_id"
    t.boolean  "featured"
    t.string   "subscription_redirect_url"
    t.string   "host_name"
  end

  create_table "affiliate_trackers", force: true do |t|
    t.integer  "referrer_id"
    t.integer  "clicks",      default: 0
    t.integer  "sign_ups",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_images", force: true do |t|
    t.string   "caption"
    t.string   "link"
    t.text     "excerpt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "blogpost_id"
  end

  create_table "blogposts", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.text     "body"
    t.string   "video_url"
    t.string   "permalink"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "view_count"
  end

  create_table "contact_advlos", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_hosts", force: true do |t|
    t.integer  "user_id"
    t.integer  "host_id"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "adventure_id"
  end

  create_table "delayed_jobs", force: true do |t|
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
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "emails", force: true do |t|
    t.string   "email"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adventure_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "capacity"
  end

  create_table "flags", force: true do |t|
    t.integer  "user_id"
    t.string   "flag_type"
    t.text     "flag_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adventure_id"
    t.integer  "reservation_id"
  end

  create_table "hero_images", force: true do |t|
    t.string   "location"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "user_id"
  end

  create_table "itineraries", force: true do |t|
    t.string   "headline"
    t.text     "description"
    t.integer  "adventure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marketing_emails", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conversation_id"
    t.boolean  "read",            default: false
  end

  create_table "payouts", force: true do |t|
    t.string   "status"
    t.integer  "user_id"
    t.string   "stripe_recipient_id"
    t.string   "stripe_transfer_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payout_via"
    t.string   "paypal_correlation_id"
    t.text     "message"
  end

  create_table "polls", force: true do |t|
    t.string   "name"
    t.integer  "answer_1",   default: 0
    t.integer  "answer_2",   default: 0
    t.integer  "answer_3",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "location"
    t.text     "description"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "budget"
    t.string   "dates"
  end

  create_table "reservations", force: true do |t|
    t.integer  "user_id"
    t.integer  "host_id"
    t.string   "stripe_recipient_id"
    t.string   "stripe_customer_id"
    t.string   "stripe_charge_id"
    t.float    "total_price"
    t.integer  "head_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "adventure_id"
    t.integer  "payout_id"
    t.boolean  "processed",           default: false
    t.datetime "event_start_time"
    t.boolean  "requested",           default: false
    t.float    "host_fee"
    t.float    "user_fee"
    t.boolean  "cancelled",           default: false
    t.text     "cancel_reason"
    t.float    "credit",              default: 0.0,   null: false
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "host_id"
    t.integer  "adventure_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "adv_rating"
    t.string   "host_rating"
  end

  create_table "user_adventures", force: true do |t|
    t.integer  "user_id"
    t.integer  "adventure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
    t.string   "charge_type"
    t.string   "stripe_subscription_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "avatar_url"
    t.string   "location"
    t.string   "skillset"
    t.string   "language"
    t.string   "sex"
    t.integer  "age"
    t.boolean  "is_guide"
    t.text     "bio"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.date     "dob"
    t.string   "short_description"
    t.string   "fb_url"
    t.string   "tw_url"
    t.string   "ta_url"
    t.string   "stripe_recipient_id"
    t.string   "stripe_customer_id"
    t.string   "rating",                 default: ""
    t.text     "avatar_meta"
    t.string   "paypal_email"
    t.string   "phone_number"
    t.string   "video_url"
    t.string   "referral_code"
    t.integer  "referrer_id"
    t.integer  "referral_count",         default: 0,     null: false
    t.float    "credit",                 default: 0.0,   null: false
    t.boolean  "email_list",             default: true
    t.string   "category"
    t.string   "stripe_subscription_id"
    t.boolean  "affiliate",              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "waivers", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

end
