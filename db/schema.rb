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

ActiveRecord::Schema.define(version: 20160214220529) do

  create_table "allergens", force: :cascade do |t|
    t.string   "name",       limit: 32, default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "allergens", ["name"], name: "allergens_name", unique: true

  create_table "families", force: :cascade do |t|
    t.integer  "num_of_members", limit: 4,   default: 1,  null: false
    t.integer  "at_home",        limit: 2,   default: 0,  null: false
    t.string   "address",        limit: 255, default: "", null: false
    t.string   "postal_code",    limit: 7,   default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "families", ["at_home"], name: "families_at_home"
  add_index "families", ["num_of_members"], name: "families_num_of_members"

  create_table "family_leaders", force: :cascade do |t|
    t.integer "family_id",  limit: 4
    t.integer "refugee_id", limit: 4
  end

  add_index "family_leaders", ["family_id"], name: "family_leaders_family_id"
  add_index "family_leaders", ["refugee_id"], name: "family_leaders_refugee_id"

  create_table "notices", force: :cascade do |t|
    t.string   "title",      limit: 255, default: "", null: false
    t.text     "content",                default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "refugee_allergens", force: :cascade do |t|
    t.integer  "refugee_id",  limit: 4
    t.integer  "allergen_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "refugee_allergens", ["allergen_id"], name: "refugee_allergens_allergen_id"
  add_index "refugee_allergens", ["refugee_id"], name: "refugee_allergens_refugee_id"

  create_table "refugee_skills", force: :cascade do |t|
    t.integer  "refugee_id", limit: 4
    t.integer  "skill_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "refugee_skills", ["refugee_id"], name: "refugee_skills_refugee_id"
  add_index "refugee_skills", ["skill_id"], name: "refugee_skills_skill_id"

  create_table "refugee_supplies", force: :cascade do |t|
    t.integer  "refugee_id", limit: 4
    t.integer  "supply_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "refugee_supplies", ["refugee_id"], name: "refugee_supplies_refugee_id"
  add_index "refugee_supplies", ["supply_id"], name: "refugee_supplies_supply_id"

  create_table "refugee_vulnerabilities", force: :cascade do |t|
    t.integer  "refugee_id",       limit: 4
    t.integer  "vulnerability_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "refugee_vulnerabilities", ["refugee_id"], name: "refugee_vul_refugee_id"
  add_index "refugee_vulnerabilities", ["vulnerability_id"], name: "refugee_vul_vulnerability_id"

  create_table "refugees", force: :cascade do |t|
    t.boolean  "presence",                       default: true,  null: false
    t.string   "name",               limit: 64,  default: "",    null: false
    t.string   "furigana",           limit: 64,  default: "",    null: false
    t.integer  "gender",             limit: 2,   default: 0,     null: false
    t.integer  "age",                limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "family_id",          limit: 4,                   null: false
    t.boolean  "password_protected",             default: false, null: false
    t.string   "password_digest",    limit: 255
    t.string   "other_allergens",    limit: 255, default: "",    null: false
  end

  add_index "refugees", ["age"], name: "refugees_age"
  add_index "refugees", ["family_id"], name: "refugees_family_id"
  add_index "refugees", ["furigana"], name: "refugees_furigana"
  add_index "refugees", ["gender"], name: "refugees_gender"
  add_index "refugees", ["name"], name: "refugees_name"
  add_index "refugees", ["presence"], name: "refugees_presence"

  create_table "shelters", force: :cascade do |t|
    t.integer  "num",         limit: 4,   default: 1,            null: false
    t.string   "name",        limit: 255, default: "ポリテクカレッジ浜松", null: false
    t.string   "postal_code", limit: 7,   default: "",           null: false
    t.string   "address",     limit: 255, default: "",           null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "shelters", ["num"], name: "shelters_num"

  create_table "skills", force: :cascade do |t|
    t.string   "name",       limit: 32, default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "skills", ["name"], name: "skills_name", unique: true

  create_table "supplies", force: :cascade do |t|
    t.string   "name",       limit: 32, default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "supplies", ["name"], name: "supplies_name", unique: true

  create_table "vulnerabilities", force: :cascade do |t|
    t.string   "name",       limit: 32, default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
