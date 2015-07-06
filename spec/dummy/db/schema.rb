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

ActiveRecord::Schema.define(version: 20150702083111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "headlines_categories", force: :cascade do |t|
    t.string   "title",       default: "",                    null: false
    t.string   "topic",       default: "",                    null: false
    t.datetime "created_at",  default: '2015-06-24 15:35:43', null: false
    t.datetime "updated_at",  default: '2015-06-24 15:35:43', null: false
    t.integer  "category_id"
    t.text     "description", default: "",                    null: false
    t.integer  "parents",     default: [],                    null: false, array: true
  end
  add_index "headlines_categories", ["parents"], name: "index_headlines_categories_on_parents", using: :btree

  create_table "headlines_domains", force: :cascade do |t|
    t.string   "name",         default: "", null: false
    t.integer  "rank",         default: 0,  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "country_code", default: "", null: false
    t.xml      "data_alexa"
  end
  add_index "headlines_domains", ["name"], name: "index_headlines_domains_on_name", unique: true, using: :btree

  create_table "headlines_domains_categories", force: :cascade do |t|
    t.integer  "category_id"
    t.datetime "created_at",  default: '2015-06-24 15:35:43', null: false
    t.datetime "updated_at",  default: '2015-06-24 15:35:43', null: false
    t.string   "domain_name"
  end
  add_index "headlines_domains_categories", ["category_id"], name: "index_headlines_domains_categories_on_category_id", using: :btree
  add_index "headlines_domains_categories", ["domain_name"], name: "index_headlines_domains_categories_on_domain_name", using: :btree

  create_table "headlines_scans", force: :cascade do |t|
    t.json     "headers",    default: {}, null: false
    t.hstore   "results",    default: {}, null: false
    t.integer  "domain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index "headlines_scans", ["domain_id"], name: "index_headlines_scans_on_domain_id", using: :btree

end
