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

ActiveRecord::Schema[8.1].define(version: 2026_09_20_123940) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "adventure_events", force: :cascade do |t|
    t.bigint "adventure_id", null: false
    t.datetime "created_at", null: false
    t.integer "elapsed_seconds", null: false
    t.integer "event_index", null: false
    t.integer "event_type", null: false
    t.jsonb "payload", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id", "event_index"], name: "index_adventure_events_on_adventure_id_and_event_index", unique: true
    t.index ["adventure_id"], name: "index_adventure_events_on_adventure_id"
  end

  create_table "adventures", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "ended_at"
    t.integer "next_event_index", default: 1, null: false
    t.integer "planned_focus_minutes", null: false
    t.bigint "random_seed", null: false
    t.bigint "start_area_id", null: false
    t.datetime "started_at", null: false
    t.integer "status", null: false
    t.bigint "timer_session_id", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_adventures_on_character_id"
    t.index ["start_area_id"], name: "index_adventures_on_start_area_id"
    t.index ["timer_session_id"], name: "index_adventures_on_timer_session_id", unique: true
  end

  create_table "area_enemies", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.datetime "created_at", null: false
    t.integer "encounter_weight", null: false
    t.bigint "enemy_id", null: false
    t.integer "level", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id", "enemy_id"], name: "index_area_enemies_on_area_id_and_enemy_id", unique: true
    t.index ["area_id"], name: "index_area_enemies_on_area_id"
    t.index ["enemy_id"], name: "index_area_enemies_on_enemy_id"
  end

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

  create_table "characters", force: :cascade do |t|
    t.integer "base_attack", default: 5, null: false
    t.integer "base_defense", default: 5, null: false
    t.integer "base_hp", default: 20, null: false
    t.integer "base_luck", default: 5, null: false
    t.integer "base_speed", default: 5, null: false
    t.datetime "created_at", null: false
    t.integer "experience_points", default: 0, null: false
    t.integer "gold", default: 100, null: false
    t.integer "level", default: 1, null: false
    t.string "name", default: "冒険者", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_characters_on_user_id", unique: true
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

  create_table "timer_sessions", force: :cascade do |t|
    t.integer "break_minutes", null: false
    t.datetime "created_at", null: false
    t.integer "focus_minutes", null: false
    t.integer "phase", null: false
    t.datetime "phase_ends_at", null: false
    t.datetime "phase_started_at", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_running_timer_sessions_on_user_id", unique: true, where: "(status = 0)"
    t.index ["user_id"], name: "index_timer_sessions_on_user_id"
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

  add_foreign_key "adventure_events", "adventures"
  add_foreign_key "adventures", "areas", column: "start_area_id"
  add_foreign_key "adventures", "characters"
  add_foreign_key "adventures", "timer_sessions"
  add_foreign_key "area_enemies", "areas"
  add_foreign_key "area_enemies", "enemies"
  add_foreign_key "areas", "areas", column: "prerequisite_area_id"
  add_foreign_key "characters", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "timer_sessions", "users"
  add_foreign_key "timer_settings", "users"
end
