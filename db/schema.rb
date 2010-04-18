# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090517111301) do

  create_table "buckets", :force => true do |t|
    t.string   "tag"
    t.string   "state"
    t.text     "boilerplate"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "milestone_id"
    t.string   "description"
  end

  create_table "lighthouse_users", :force => true do |t|
    t.string   "name"
    t.integer  "lighthouse_id"
    t.string   "website"
    t.string   "job"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lighthouse_id"
  end

  create_table "projects", :force => true do |t|
    t.integer  "lighthouse_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_results", :force => true do |t|
    t.integer  "search_id"
    t.integer  "ticket_number"
    t.string   "title"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "project_id"
    t.string   "query"
    t.string   "name"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tickets", :force => true do |t|
    t.integer  "project_id"
    t.integer  "number"
    t.string   "title"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "api_key",                   :limit => 100
    t.string   "subdomain",                 :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
