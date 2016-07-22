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

ActiveRecord::Schema.define(version: 20160722154211) do

  create_table "admin_associations", force: :cascade do |t|
    t.integer  "user_id",       limit: 4, null: false
    t.integer  "dependency_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_associations", ["dependency_id"], name: "index_admin_associations_on_dependency_id", using: :btree
  add_index "admin_associations", ["user_id"], name: "index_admin_associations_on_user_id", using: :btree

  create_table "applicants", force: :cascade do |t|
    t.string   "ocupation",                     limit: 255
    t.integer  "audience_id",                   limit: 4
    t.integer  "represented_person_id",         limit: 4
    t.string   "represented_person_ocupation",  limit: 255
    t.integer  "represented_legal_entity_id",   limit: 4
    t.integer  "represented_state_organism_id", limit: 4
    t.integer  "represented_people_group_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id",                     limit: 4
    t.boolean  "absent",                        limit: 1
  end

  add_index "applicants", ["person_id"], name: "index_applicants_on_person_id", using: :btree

  create_table "audiences", force: :cascade do |t|
    t.datetime "date"
    t.datetime "publish_date"
    t.text     "summary",          limit: 65535
    t.boolean  "published",        limit: 1
    t.string   "place",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "obligee_id",       limit: 4
    t.integer  "applicant_id",     limit: 4
    t.decimal  "lat",                            precision: 10, scale: 6
    t.decimal  "lng",                            precision: 10, scale: 6
    t.string   "motif",            limit: 255
    t.integer  "author_id",        limit: 4
    t.string   "interest_invoked", limit: 255
    t.boolean  "deleted",          limit: 1,                              default: false
    t.date     "deleted_at"
    t.string   "address",          limit: 255
  end

  add_index "audiences", ["applicant_id"], name: "index_audiences_on_applicant_id", using: :btree
  add_index "audiences", ["author_id"], name: "index_audiences_on_author_id", using: :btree
  add_index "audiences", ["obligee_id"], name: "index_audiences_on_obligee_id", using: :btree

  create_table "dependencies", force: :cascade do |t|
    t.string   "name",       limit: 255,                null: false
    t.integer  "obligee_id", limit: 4
    t.integer  "parent_id",  limit: 4
    t.boolean  "active",     limit: 1,   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependencies", ["obligee_id"], name: "index_dependencies_on_obligee_id", using: :btree
  add_index "dependencies", ["parent_id"], name: "index_dependencies_on_parent_id", using: :btree

  create_table "legal_entities", force: :cascade do |t|
    t.string   "country",    limit: 255
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "telephone",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cuit",       limit: 255
  end

  create_table "obligees", force: :cascade do |t|
    t.integer  "person_id",     limit: 4,                  null: false
    t.integer  "dependency_id", limit: 4,                  null: false
    t.boolean  "active",        limit: 1,   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "position",      limit: 255
  end

  add_index "obligees", ["dependency_id"], name: "index_obligees_on_dependency_id", using: :btree
  add_index "obligees", ["person_id"], name: "index_obligees_on_person_id", using: :btree

  create_table "old_audiences", force: :cascade do |t|
    t.integer  "id_audiencia",                      limit: 4
    t.string   "apellido_sujeto_obligado",          limit: 255
    t.string   "nombre_sujeto_obligado",            limit: 255
    t.string   "cargo_sujeto_obligado",             limit: 255
    t.string   "dependencia_sujeto_obligado",       limit: 255
    t.string   "super_dependencia",                 limit: 255
    t.datetime "fecha_solicitud_audiencia"
    t.string   "apellido_solicitante",              limit: 255
    t.string   "nombre_solicitante",                limit: 255
    t.string   "cargo_solicitante",                 limit: 255
    t.string   "tipo_documento_solicitante",        limit: 255
    t.string   "numero_documento_solicitante",      limit: 255
    t.string   "interes_invocado",                  limit: 255
    t.string   "caracter_en_que_participa",         limit: 255
    t.string   "apellido_descripcion_representado", limit: 255
    t.string   "nombre_representado",               limit: 255
    t.string   "cargo_representado",                limit: 255
    t.string   "domicilio_representado",            limit: 255
    t.string   "numero_documento_representadoo",    limit: 255
    t.datetime "fecha_hora_audiencia"
    t.string   "lugar_audiencia",                   limit: 255
    t.string   "objeto_audiencia",                  limit: 255
    t.text     "participante_audiencia",            limit: 65535
    t.string   "estado_cancelada_audiencia",        limit: 255
    t.string   "estado_audiencia",                  limit: 255
    t.text     "sintesis_audiencia",                limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "es_persona_juridica",               limit: 1
    t.string   "derivada_a_apellido",               limit: 255
    t.string   "derivada_a_nombre",                 limit: 255
    t.string   "derivada_a_cargo",                  limit: 255
  end

  add_index "old_audiences", ["id_audiencia"], name: "index_old_audiences_on_id_audiencia", using: :btree

  create_table "operator_associations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "obligee_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operator_associations", ["obligee_id"], name: "index_operator_associations_on_obligee_id", using: :btree
  add_index "operator_associations", ["user_id"], name: "index_operator_associations_on_user_id", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "audience_id", limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id",   limit: 4
    t.string   "ocupation",   limit: 255
  end

  add_index "participants", ["audience_id"], name: "index_participants_on_audience_id", using: :btree
  add_index "participants", ["person_id"], name: "index_participants_on_person_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "person_id",  limit: 255, null: false
    t.string   "name",       limit: 255, null: false
    t.string   "telephone",  limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_type",    limit: 255
    t.string   "country",    limit: 255
  end

  add_index "people", ["person_id"], name: "index_people_on_person_id", using: :btree

  create_table "people_groups", force: :cascade do |t|
    t.string   "country",     limit: 255
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.string   "telephone",   limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "state_organisms", force: :cascade do |t|
    t.string   "country",    limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "person_id",              limit: 4,                   null: false
    t.string   "name",                   limit: 255,                 null: false
    t.string   "email",                  limit: 255,                 null: false
    t.string   "telephone",              limit: 255
    t.string   "password_digest",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_superadmin",          limit: 1,   default: false
    t.string   "auth_token",             limit: 255
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
    t.string   "id_type",                limit: 255
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree

end
