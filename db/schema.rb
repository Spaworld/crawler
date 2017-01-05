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

ActiveRecord::Schema.define(version: 20170105055350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "listings", force: :cascade do |t|
    t.string   "sku"
    t.datetime "created_at",                                                                                                                                  null: false
    t.datetime "updated_at",                                                                                                                                  null: false
    t.jsonb    "vendors",       default: {"hd"=>nil, "hmb"=>nil, "build"=>nil, "houzz"=>nil, "lowes"=>nil, "menards"=>nil, "wayfair"=>nil, "overstock"=>nil}
    t.string   "hd_url"
    t.string   "overstock_url"
    t.string   "menards_url"
    t.string   "hmb_url"
    t.string   "build_url"
    t.string   "houzz_url"
    t.string   "lowes_url"
    t.string   "wayfair_url"
  end

end
