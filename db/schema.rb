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

ActiveRecord::Schema.define(version: 20160412155600) do

  create_table "admin_associations", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "dependency_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_associations", ["dependency_id"], name: "index_admin_associations_on_dependency_id"
  add_index "admin_associations", ["user_id"], name: "index_admin_associations_on_user_id"

  create_table "obligees", force: :cascade do |t|
    t.integer  "person_id",                    null: false
    t.integer  "dependency_id",                null: false
    t.integer  "position_id",                  null: false
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "obligees", ["dependency_id"], name: "index_obligees_on_dependency_id"
  add_index "obligees", ["person_id"], name: "index_obligees_on_person_id"
  add_index "obligees", ["position_id"], name: "index_obligees_on_position_id"

  create_table "operator_associations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "obligee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operator_associations", ["obligee_id"], name: "index_operator_associations_on_obligee_id"
  add_index "operator_associations", ["user_id"], name: "index_operator_associations_on_user_id"

  create_table "users", force: :cascade do |t|
    t.integer  "dni",                             null: false
    t.string   "name",                            null: false
    t.string   "surname",                         null: false
    t.string   "email",                           null: false
    t.string   "telephone"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_superadmin",   default: false
  end

end
