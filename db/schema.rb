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

ActiveRecord::Schema.define(version: 20140323203317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_members_on_account_id", using: :btree
    t.index ["user_id", "account_id"], name: "index_account_members_on_user_id_and_account_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_account_members_on_user_id", using: :btree
  end

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "deployments", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "node_id",                         null: false
    t.string   "state",       default: "initial", null: false
    t.text     "logs"
    t.boolean  "success"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "finished_at"
    t.index ["node_id"], name: "index_deployments_on_node_id", using: :btree
    t.index ["user_id"], name: "index_deployments_on_user_id", using: :btree
  end

  create_table "nodes", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.text     "credentials"
    t.text     "config"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["project_id"], name: "index_nodes_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",          null: false
    t.integer  "user_id",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "cookbooks"
    t.text     "cookbooks_lock"
    t.index ["title"], name: "index_projects_on_title", using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "name"
    t.text     "config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_roles_on_project_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "super_admin",            default: false
    t.string   "last_name"
    t.string   "first_name"
    t.string   "role",                   default: "standard"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
