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

ActiveRecord::Schema[7.1].define(version: 2024_11_24_225808) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "street", null: false
    t.string "secondary"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.string "country", null: false
    t.integer "address_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "appointment_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "appointment_id", null: false
    t.uuid "address_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_appointment_addresses_on_address_id"
    t.index ["appointment_id"], name: "index_appointment_addresses_on_appointment_id"
  end

  create_table "appointment_projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "appointment_id", null: false
    t.uuid "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_projects_on_appointment_id"
    t.index ["project_id"], name: "index_appointment_projects_on_project_id"
  end

  create_table "appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "appointment_type", default: 0
    t.integer "status", default: 0
    t.boolean "new_customer"
    t.text "note"
    t.date "scheduled_date"
    t.time "scheduled_start"
    t.time "scheduled_end"
    t.uuid "created_by_id"
    t.uuid "completed_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_name"
    t.index ["completed_by_id"], name: "index_appointments_on_completed_by_id"
    t.index ["created_by_id"], name: "index_appointments_on_created_by_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sent_to_id_id", null: false
    t.integer "notification_type"
    t.text "message"
    t.datetime "sent_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_to_id_id"], name: "index_notifications_on_sent_to_id_id"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "project_name", null: false
    t.text "description"
    t.text "note"
    t.integer "status", default: 0
    t.datetime "target_completion"
    t.string "delivery_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_link"
    t.boolean "video_embedded", default: false
    t.boolean "customer_info_supplied", default: false
    t.boolean "revision_requested", default: false
    t.integer "closed_by_id"
    t.datetime "closed_at"
  end

  create_table "user_appointments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "appointment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_user_appointments_on_appointment_id"
    t.index ["user_id"], name: "index_user_appointments_on_user_id"
  end

  create_table "user_projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 2, null: false
    t.string "name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id"], name: "index_users_on_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointment_addresses", "addresses"
  add_foreign_key "appointment_addresses", "appointments"
  add_foreign_key "appointment_projects", "appointments"
  add_foreign_key "appointment_projects", "projects"
  add_foreign_key "appointments", "users", column: "completed_by_id"
  add_foreign_key "appointments", "users", column: "created_by_id"
  add_foreign_key "notifications", "users", column: "sent_to_id_id"
  add_foreign_key "user_appointments", "appointments"
  add_foreign_key "user_appointments", "users"
  add_foreign_key "user_projects", "projects"
  add_foreign_key "user_projects", "users"
end
