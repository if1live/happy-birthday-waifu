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

ActiveRecord::Schema.define(version: 20150128032417) do

  create_table "characters", force: :cascade do |t|
    t.string   "slug"
    t.string   "name_en"
    t.string   "name_ko"
    t.integer  "year"
    t.string   "date",         limit: 5
    t.string   "external_url",           default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
