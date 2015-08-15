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

ActiveRecord::Schema.define(version: 20150815114800) do

  create_table "families", force: :cascade do |t|
    t.integer  "num_of_members",                        null: false
    t.integer  "at_home",        limit: 1, default: 0,  null: false
    t.string   "address",                  default: "", null: false
    t.string   "postal_code",    limit: 7, default: "", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "families", ["at_home"], name: "index_families_on_at_home"
  add_index "families", ["num_of_members"], name: "index_families_on_num_of_members"

end
