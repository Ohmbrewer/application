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

ActiveRecord::Schema.define(version: 20151201030515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "batches", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "stop_time"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "equipment_profiles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment_statuses", force: :cascade do |t|
    t.integer  "equipment_id"
    t.string   "type"
    t.integer  "state"
    t.datetime "stop_time"
    t.jsonb    "data",         default: {}
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "task_id"
  end

  add_index "equipment_statuses", ["data"], name: "index_equipment_statuses_on_data", using: :btree
  add_index "equipment_statuses", ["equipment_id"], name: "index_equipment_statuses_on_equipment_id", using: :btree
  add_index "equipment_statuses", ["task_id"], name: "index_equipment_statuses_on_task_id", using: :btree

  create_table "equipments", force: :cascade do |t|
    t.string   "type"
    t.jsonb    "pins",          default: {}, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "thermostat_id"
    t.integer  "rims_id"
  end

  add_index "equipments", ["pins"], name: "index_equipments_on_pins", using: :btree
  add_index "equipments", ["rims_id"], name: "index_equipments_on_rims_id", using: :btree
  add_index "equipments", ["thermostat_id"], name: "index_equipments_on_thermostat_id", using: :btree

  create_table "particle_devices", force: :cascade do |t|
    t.string   "device_id",              null: false
    t.string   "encrypted_access_token"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "rhizome_id"
  end

  add_index "particle_devices", ["device_id"], name: "index_particle_devices_on_device_id", unique: true, using: :btree
  add_index "particle_devices", ["rhizome_id"], name: "index_particle_devices_on_rhizome_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "schedule_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "batch_id"
  end

  add_index "recipes", ["batch_id"], name: "index_recipes_on_batch_id", using: :btree

  create_table "recirculating_infusion_mash_systems", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rhizome_roles", force: :cascade do |t|
    t.integer "batch_id"
    t.integer "role_id"
    t.integer "rhizome_id"
  end

  create_table "rhizomes", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "batch_id"
  end

  add_index "rhizomes", ["batch_id"], name: "index_rhizomes_on_batch_id", using: :btree

  create_table "schedule_profiles", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "equipment_profile_id"
  end

  add_index "schedule_profiles", ["equipment_profile_id"], name: "index_schedule_profiles_on_equipment_profile_id", using: :btree
  add_index "schedule_profiles", ["schedule_id"], name: "index_schedule_profiles_on_schedule_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.string   "name"
    t.integer  "root_task_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sprouts", force: :cascade do |t|
    t.integer "sproutable_id"
    t.string  "sproutable_type"
    t.integer "equipment_profile_id"
  end

  add_index "sprouts", ["equipment_profile_id"], name: "index_sprouts_on_equipment_profile_id", using: :btree
  add_index "sprouts", ["sproutable_type", "sproutable_id"], name: "index_sprouts_on_sproutable_type_and_sproutable_id", using: :btree

  create_table "task_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "task_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "task_anc_desc_idx", unique: true, using: :btree
  add_index "task_hierarchies", ["descendant_id"], name: "task_desc_idx", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "type"
    t.integer  "status"
    t.jsonb    "update_data",                           default: {}
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "equipment_id"
    t.integer  "schedule_id"
    t.integer  "duration",                              default: 0
    t.integer  "parent_id"
    t.integer  "sort_order"
    t.integer  "trigger"
    t.uuid     "job_id"
    t.integer  "thermostat_id"
    t.integer  "ramp_estimate",                         default: 0
    t.integer  "recirculating_infusion_mash_system_id"
  end

  add_index "tasks", ["schedule_id"], name: "index_tasks_on_schedule_id", using: :btree
  add_index "tasks", ["update_data"], name: "index_tasks_on_update_data", using: :btree

  create_table "thermostats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "rims_id"
  end

  add_index "thermostats", ["rims_id"], name: "index_thermostats_on_rims_id", using: :btree

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
end
