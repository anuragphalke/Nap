# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_27_133010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "all_appliances", force: :cascade do |t|
    t.text "category"
    t.text "subcategory"
    t.text "brand"
    t.text "model"
    t.decimal "wattage", precision: 10, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.text "title"
    t.text "content"
    t.text "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "averages", force: :cascade do |t|
    t.string "day"
    t.datetime "time", precision: nil
    t.decimal "average"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.datetime "datetime", precision: nil
    t.decimal "cost", precision: 10, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "routine_id"
    t.decimal "cost", precision: 10, scale: 4
    t.time "starttime"
    t.time "endtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_recommendations_on_routine_id"
  end

  create_table "routines", force: :cascade do |t|
    t.decimal "cost", precision: 10, scale: 4
    t.datetime "starttime", precision: nil
    t.datetime "endtime", precision: nil
    t.string "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_appliance_id"
  end

  create_table "user_appliances", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "all_appliance_id"
    t.index ["user_id"], name: "index_user_appliances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "recommendations", "routines"
  add_foreign_key "routines", "user_appliances"
  add_foreign_key "user_appliances", "all_appliances"
  add_foreign_key "user_appliances", "users"
end
