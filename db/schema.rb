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

ActiveRecord::Schema[7.1].define(version: 2024_11_25_141517) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "averages", force: :cascade do |t|
    t.bigint "price_id", null: false
    t.date "day"
    t.time "time"
    t.float "average"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_id"], name: "index_averages_on_price_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "category"
    t.boolean "state"
    t.float "total_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "prices", force: :cascade do |t|
    t.date "date"
    t.float "hour00"
    t.float "hour01"
    t.float "hour02"
    t.float "hour03"
    t.float "hour04"
    t.float "hour05"
    t.float "hour06"
    t.float "hour07"
    t.float "hour08"
    t.float "hour09"
    t.float "hour10"
    t.float "hour11"
    t.float "hour12"
    t.float "hour13"
    t.float "hour14"
    t.float "hour15"
    t.float "hour16"
    t.float "hour17"
    t.float "hour18"
    t.float "hour19"
    t.float "hour20"
    t.float "hour21"
    t.float "hour22"
    t.float "hour23"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "routine_id", null: false
    t.float "cost"
    t.text "content"
    t.time "starttime"
    t.time "endtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_recommendations_on_routine_id"
  end

  create_table "routines", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.float "cost"
    t.time "starttime"
    t.time "endtime"
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_routines_on_device_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "averages", "prices"
  add_foreign_key "devices", "users"
  add_foreign_key "recommendations", "routines"
  add_foreign_key "routines", "devices"
end
