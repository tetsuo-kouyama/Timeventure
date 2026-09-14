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

ActiveRecord::Schema[8.1].define(version: 2026_09_14_022513) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "areas", force: :cascade do |t|
    t.integer "area_type", null: false
    t.integer "battle_weight", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "prerequisite_area_id"
    t.integer "treasure_weight", null: false
    t.datetime "updated_at", null: false
    t.index ["prerequisite_area_id"], name: "index_areas_on_prerequisite_area_id"
  end

  create_table "enemies", force: :cascade do |t|
    t.integer "base_attack", null: false
    t.integer "base_defense", null: false
    t.integer "base_hp", null: false
    t.integer "base_luck", null: false
    t.integer "base_speed", null: false
    t.datetime "created_at", null: false
    t.integer "drop_experience_points", null: false
    t.integer "drop_gold", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "timer_settings", force: :cascade do |t|
    t.integer "break_minutes", default: 5, null: false
    t.datetime "created_at", null: false
    t.integer "focus_minutes", default: 25, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_timer_settings_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.boolean "guest", default: false, null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "areas", "areas", column: "prerequisite_area_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "timer_settings", "users"
end
