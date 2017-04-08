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

ActiveRecord::Schema.define(version: 20170408031718) do

  create_table "books", force: :cascade do |t|
    t.string   "name"
    t.string   "author"
    t.string   "genre"
    t.integer  "pages"
    t.string   "publisher"
    t.date     "publication_date"
    t.integer  "availability"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "description"
    t.integer  "number_of_borrowing_days"
    t.integer  "dewey_code"
  end

  create_table "borrowings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "borrowed_time"
    t.datetime "due_date"
    t.boolean  "verified",            default: false
    t.integer  "number_of_extension", default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "request",             default: "borrow"
    t.index ["book_id"], name: "index_borrowings_on_book_id"
    t.index ["user_id", "book_id"], name: "index_borrowings_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_borrowings_on_user_id"
  end

  create_table "deweys", force: :cascade do |t|
    t.string   "code"
    t.string   "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "seen",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
    t.string   "email"
    t.date     "birthday"
    t.string   "address"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",                default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "number_of_borrowed_books", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
