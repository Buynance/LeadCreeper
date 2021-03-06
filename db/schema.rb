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

ActiveRecord::Schema.define(version: 20141107055554) do

  create_table "businesses", force: true do |t|
    t.string   "twilio_number"
    t.string   "mobile_number"
    t.string   "landline_number"
    t.string   "opt_in_code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "businesses_customers", force: true do |t|
    t.integer "business_id", null: false
    t.integer "customer_id", null: false
    t.string  "state"
  end

  create_table "customers", force: true do |t|
    t.string   "mobile_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
