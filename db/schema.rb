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

ActiveRecord::Schema.define(version: 2018_10_30_195007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "value"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
    t.index ["value"], name: "index_categories_on_value", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
    t.index ["slug"], name: "index_countries_on_slug", unique: true
  end

  create_table "federal_states", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "code"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_federal_states_on_code", unique: true
    t.index ["country_code"], name: "index_federal_states_on_country_code"
    t.index ["name"], name: "index_federal_states_on_name", unique: true
    t.index ["slug"], name: "index_federal_states_on_slug", unique: true
  end

  create_table "years", force: :cascade do |t|
    t.integer "value"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_years_on_slug", unique: true
    t.index ["value"], name: "index_years_on_value", unique: true
  end

end