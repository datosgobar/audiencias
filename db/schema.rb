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

ActiveRecord::Schema.define(version: 20160414100000) do

  create_table "admin_associations", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "dependency_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_associations", ["dependency_id"], name: "index_admin_associations_on_dependency_id"
  add_index "admin_associations", ["user_id"], name: "index_admin_associations_on_user_id"

  create_table "audiences", force: :cascade do |t|
    t.integer  "obligee_id",       null: false
    t.integer  "applicant_id",     null: false
    t.datetime "application_date", null: false
    t.datetime "date"
    t.datetime "publish_date"
    t.integer  "status"
    t.string   "summary"
    t.integer  "interest_invoked"
    t.boolean  "published"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audiences", ["applicant_id"], name: "index_audiences_on_applicant_id"
  add_index "audiences", ["obligee_id"], name: "index_audiences_on_obligee_id"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependencies", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "obligee_id",                 null: false
    t.integer  "position_id",                null: false
    t.integer  "parent_id"
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependencies", ["obligee_id"], name: "index_dependencies_on_obligee_id"
  add_index "dependencies", ["parent_id"], name: "index_dependencies_on_parent_id"
  add_index "dependencies", ["position_id"], name: "index_dependencies_on_position_id"

  create_table "involved", force: :cascade do |t|
    t.integer  "person_id",      null: false
    t.integer  "position_id"
    t.integer  "represented_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "involved", ["company_id"], name: "index_involved_on_company_id"
  add_index "involved", ["person_id"], name: "index_involved_on_person_id"
  add_index "involved", ["position_id"], name: "index_involved_on_position_id"
  add_index "involved", ["represented_id"], name: "index_involved_on_represented_id"

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

  create_table "participants", force: :cascade do |t|
    t.integer  "involved_id", null: false
    t.integer  "audience_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["audience_id"], name: "index_participants_on_audience_id"
  add_index "participants", ["involved_id"], name: "index_participants_on_involved_id"

  create_table "positions", force: :cascade do |t|
    t.string   "name",                         null: false
    t.integer  "obligee_id",                   null: false
    t.integer  "dependency_id",                null: false
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "positions", ["dependency_id"], name: "index_positions_on_dependency_id"
  add_index "positions", ["obligee_id"], name: "index_positions_on_obligee_id"

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
