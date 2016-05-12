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

ActiveRecord::Schema.define(version: 20160512110000) do

  create_table "admin_associations", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "dependency_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_associations", ["dependency_id"], name: "index_admin_associations_on_dependency_id"
  add_index "admin_associations", ["user_id"], name: "index_admin_associations_on_user_id"

  create_table "audiences", force: :cascade do |t|
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

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dependencies", force: :cascade do |t|
    t.string   "name",                      null: false
    t.integer  "obligee_id"
    t.integer  "parent_id"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependencies", ["obligee_id"], name: "index_dependencies_on_obligee_id"
  add_index "dependencies", ["parent_id"], name: "index_dependencies_on_parent_id"

  create_table "obligees", force: :cascade do |t|
    t.integer  "person_id",                    null: false
    t.integer  "dependency_id",                null: false
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position"
  end

  add_index "obligees", ["dependency_id"], name: "index_obligees_on_dependency_id"
  add_index "obligees", ["person_id"], name: "index_obligees_on_person_id"

  create_table "operator_associations", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "obligee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operator_associations", ["obligee_id"], name: "index_operator_associations_on_obligee_id"
  add_index "operator_associations", ["user_id"], name: "index_operator_associations_on_user_id"

  create_table "participants", force: :cascade do |t|
    t.integer  "audience_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dependency_id"
    t.integer  "person_id"
    t.integer  "represented_id"
    t.integer  "company_id"
    t.boolean  "applicant",      default: false
    t.boolean  "requested",      default: false
  end

  add_index "participants", ["audience_id"], name: "index_participants_on_audience_id"
  add_index "participants", ["company_id"], name: "index_participants_on_company_id"
  add_index "participants", ["dependency_id"], name: "index_participants_on_dependency_id"
  add_index "participants", ["person_id"], name: "index_participants_on_person_id"
  add_index "participants", ["represented_id"], name: "index_participants_on_represented_id"

  create_table "people", force: :cascade do |t|
    t.string   "person_id",  null: false
    t.string   "name",       null: false
    t.string   "surname",    null: false
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_type"
    t.string   "country"
  end

  add_index "people", ["person_id"], name: "index_people_on_person_id"

  create_table "users", force: :cascade do |t|
    t.integer  "person_id",                              null: false
    t.string   "name",                                   null: false
    t.string   "surname",                                null: false
    t.string   "email",                                  null: false
    t.string   "telephone"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_superadmin",          default: false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "id_type"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token"

end
