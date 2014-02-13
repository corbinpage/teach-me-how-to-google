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

ActiveRecord::Schema.define(version: 20140211224915) do

  create_table "results", force: true do |t|
    t.string   "status"
    t.string   "error"
    t.text     "search_info_string"
    t.string   "item_titles"
    t.string   "item_links"
    t.string   "item_display_links"
    t.text     "item_snippets"
    t.string   "custom1"
    t.string   "custom2"
    t.text     "custom3"
    t.integer  "search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["search_id"], name: "index_results_on_search_id"

  create_table "searches", force: true do |t|
    t.string   "step"
    t.integer  "search_num"
    t.text     "search_text"
    t.string   "status"
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["session_id"], name: "index_searches_on_session_id"

  create_table "sessions", force: true do |t|
    t.string   "ip"
    t.string   "name"
    t.datetime "start_time"
    t.text     "custom1"
    t.text     "custom2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
