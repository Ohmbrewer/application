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

ActiveRecord::Schema.define(version: 20150802035232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "particle_devices", force: :cascade do |t|
    t.string   "device_id",              null: false
    t.string   "encrypted_access_token"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "rhizome_id"
  end

  add_index "particle_devices", ["device_id"], name: "index_particle_devices_on_device_id", unique: true, using: :btree
  add_index "particle_devices", ["rhizome_id"], name: "index_particle_devices_on_rhizome_id", using: :btree

  create_table "pump_statuses", force: :cascade do |t|
    t.string   "device_id"
    t.integer  "pump_id"
    t.string   "state"
    t.datetime "stop_time"
    t.integer  "speed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rhizomes", force: :cascade do |t|
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "particle_id"
  end

  add_index "rhizomes", ["particle_id"], name: "index_rhizomes_on_particle_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
    t.boolean  "admin",                       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "particle_devices", "rhizomes"
  add_foreign_key "rhizomes", "particle_devices", column: "particle_id"
end
