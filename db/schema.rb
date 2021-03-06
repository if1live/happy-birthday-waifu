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

ActiveRecord::Schema.define(version: 20150308051615) do

  create_table "characters", force: :cascade do |t|
    t.string   "slug"
    t.string   "name_en"
    t.string   "name_ko"
    t.string   "name_jp"
    t.integer  "year"
    t.string   "date",             limit: 5
    t.string   "external_url",               default: ""
    t.integer  "anime_db_id"
    t.string   "anime_db_img_url"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "source_id"
  end

  add_index "characters", ["date"], name: "index_characters_on_date"
  add_index "characters", ["slug"], name: "index_characters_on_slug", unique: true
  add_index "characters", ["source_id"], name: "index_characters_on_source_id"

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "character_id", null: false
    t.integer  "noti_year"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "favorites", ["user_id", "character_id"], name: "index_favorites_on_user_id_and_character_id", unique: true

  create_table "sources", force: :cascade do |t|
    t.string   "slug"
    t.string   "title_en"
    t.string   "title_jp"
    t.string   "title_romaji"
    t.string   "title_furigana"
    t.integer  "anime_db_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "sources", ["anime_db_id"], name: "index_sources_on_anime_db_id", unique: true
  add_index "sources", ["slug"], name: "index_sources_on_slug", unique: true

  create_table "users", force: :cascade do |t|
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
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
