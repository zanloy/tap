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

ActiveRecord::Schema.define(version: 20150528183723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.text     "comment",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["ticket_id"], name: "index_comments_on_ticket_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "project_id",                 null: false
    t.integer  "user_id",                    null: false
    t.integer  "role",       default: 0
    t.boolean  "admin",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "memberships", ["project_id"], name: "index_memberships_on_project_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "icon"
    t.boolean  "private",            default: false
    t.integer  "auto_assignee_id"
    t.boolean  "show_in_navbar",     default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "notification_email"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "name"
    t.integer  "quantity",   default: 1
    t.float    "cost",       default: 0.0
    t.string   "url"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "purchases", ["ticket_id"], name: "index_purchases_on_ticket_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "project_id",                             null: false
    t.integer  "reporter_id",                            null: false
    t.integer  "assignee_id"
    t.boolean  "closed",                 default: false
    t.boolean  "archived",               default: false
    t.integer  "priority",               default: 1
    t.string   "title",                                  null: false
    t.text     "description"
    t.integer  "closed_by_id"
    t.datetime "closed_at"
    t.integer  "approving_manager_id"
    t.datetime "manager_approved_at"
    t.integer  "approving_executive_id"
    t.datetime "executive_approved_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "tickets", ["assignee_id"], name: "index_tickets_on_assignee_id", using: :btree
  add_index "tickets", ["project_id"], name: "index_tickets_on_project_id", using: :btree
  add_index "tickets", ["reporter_id"], name: "index_tickets_on_reporter_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "name"
    t.integer  "role",             default: 0
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_foreign_key "comments", "tickets"
  add_foreign_key "comments", "users"
  add_foreign_key "memberships", "projects"
  add_foreign_key "memberships", "users"
  add_foreign_key "purchases", "tickets"
  add_foreign_key "tickets", "projects"
end
