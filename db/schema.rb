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

ActiveRecord::Schema.define(version: 20170122055415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string   "business_name"
    t.string   "dba"
    t.string   "website"
    t.string   "tax_id"
    t.string   "office_address"
    t.string   "office_city"
    t.string   "office_state"
    t.string   "office_zip"
    t.string   "office_mailing_address"
    t.string   "office_mailing_city"
    t.string   "office_mailing_state"
    t.string   "office_mailing_zip"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "license_number"
    t.string   "license_state"
    t.date     "expiration_date"
    t.string   "eo_carrier_name"
    t.string   "eo_policy_number"
    t.string   "eo_expiration_date"
    t.string   "header_from"
    t.text     "comments"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string   "sku"
    t.datetime "created_at",                                                                                                                          null: false
    t.datetime "updated_at",                                                                                                                          null: false
    t.jsonb    "vendors",       default: {"hd"=>{}, "hmb"=>{}, "build"=>{}, "houzz"=>{}, "lowes"=>{}, "menards"=>{}, "wayfair"=>{}, "overstock"=>{}}
    t.string   "hd_url"
    t.string   "overstock_url"
    t.string   "menards_url"
    t.string   "hmb_url"
    t.string   "build_url"
    t.string   "houzz_url"
    t.string   "lowes_url"
    t.string   "wayfair_url"
    t.string   "amazon_url"
  end

  create_table "quotes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_requests", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "subject"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
