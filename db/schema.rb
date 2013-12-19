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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131219185307) do

  create_table "clients", :force => true do |t|
    t.integer  "user_id"
    t.string   "client_name",  :limit => 55
    t.boolean  "enabled",                    :default => true
    t.string   "api_key"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "customer_key", :limit => 55
  end

  add_index "clients", ["api_key"], :name => "index_clients_on_api_key"
  add_index "clients", ["customer_key"], :name => "index_clients_on_customer_key"

  create_table "contacts", :force => true do |t|
    t.integer  "client_id"
    t.string   "first_name",  :limit => 55
    t.string   "last_name",   :limit => 55
    t.string   "email"
    t.string   "phone"
    t.string   "payment_pin"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "invoice_items", :primary_key => "invoice_item_id", :force => true do |t|
    t.integer  "invoice_id"
    t.decimal  "amount"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "invoices", :primary_key => "invoice_id", :force => true do |t|
    t.decimal  "amount"
    t.decimal  "tax"
    t.decimal  "total"
    t.string   "invoice_key"
    t.datetime "paid_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "client_id"
  end

  create_table "projects", :force => true do |t|
    t.integer  "client_id"
    t.string   "project_name"
    t.string   "project_type"
    t.date     "due_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
