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

ActiveRecord::Schema.define(version: 2017_10_23_174946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "video_limit"
    t.integer "max_videos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_account_types_on_name", unique: true
  end

  create_table "general_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "setting_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_general_settings_on_setting_id"
    t.index ["user_id", "setting_id"], name: "index_general_settings_on_user_id_and_setting_id", unique: true
    t.index ["user_id"], name: "index_general_settings_on_user_id"
  end

  create_table "profile_settings", id: :serial, force: :cascade do |t|
    t.integer "profile_id"
    t.integer "setting_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id", "setting_id"], name: "index_profile_settings_on_profile_id_and_setting_id", unique: true
    t.index ["profile_id"], name: "index_profile_settings_on_profile_id"
    t.index ["setting_id"], name: "index_profile_settings_on_setting_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_profiles_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "setting_type"
    t.string "default_value"
    t.boolean "strict_values"
    t.string "allowed_values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "parent_digest", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_type_id"
    t.index ["account_type_id"], name: "index_users_on_account_type_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "video_tags", id: :serial, force: :cascade do |t|
    t.integer "video_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_video_tags_on_tag_id"
    t.index ["video_id"], name: "index_video_tags_on_video_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "youtube_id", null: false
    t.boolean "approved", default: false, null: false
    t.integer "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail"
    t.string "title"
    t.boolean "has_cc"
    t.index ["profile_id", "youtube_id"], name: "index_videos_on_profile_id_and_youtube_id", unique: true
    t.index ["profile_id"], name: "index_videos_on_profile_id"
  end

  add_foreign_key "general_settings", "settings"
  add_foreign_key "general_settings", "users"
  add_foreign_key "profile_settings", "profiles"
  add_foreign_key "profile_settings", "settings"
  add_foreign_key "profiles", "users"
  add_foreign_key "tags", "users"
  add_foreign_key "users", "account_types"
  add_foreign_key "video_tags", "tags"
  add_foreign_key "video_tags", "videos"
  add_foreign_key "videos", "profiles"
end
