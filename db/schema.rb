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

ActiveRecord::Schema.define(version: 20150815141616) do

  create_table "families", force: :cascade do |t|
    t.integer  "num_of_members",           default: 1,  null: false
    t.integer  "at_home",        limit: 1, default: 0,  null: false
    t.string   "address",                  default: "", null: false
    t.string   "postal_code",    limit: 7, default: "", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "families", ["at_home"], name: "index_families_on_at_home"
  add_index "families", ["num_of_members"], name: "index_families_on_num_of_members"

  create_table "refugees", force: :cascade do |t|
    t.boolean  "presence",              default: true, null: false
    t.string   "name",       limit: 64, default: "",   null: false
    t.string   "furigana",   limit: 64, default: "",   null: false
    t.integer  "gender",     limit: 1,  default: 0,    null: false
    t.integer  "age"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "refugees", ["age"], name: "index_refugees_on_age"
  add_index "refugees", ["furigana"], name: "index_refugees_on_furigana"
  add_index "refugees", ["gender"], name: "index_refugees_on_gender"
  add_index "refugees", ["name"], name: "index_refugees_on_name"
  add_index "refugees", ["presence"], name: "index_refugees_on_presence"

end
