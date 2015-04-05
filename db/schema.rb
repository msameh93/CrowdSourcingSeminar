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

ActiveRecord::Schema.define(version: 20150331180113) do

  create_table "games", force: :cascade do |t|
    t.string   "player1_id"
    t.string   "player2_id"
    t.string   "curr_word"
    t.string   "hint"
    t.integer  "turn"
    t.integer  "guess_no"
    t.boolean  "hints_finished"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string   "sender_id"
    t.string   "receiver_id"
    t.string   "word"
    t.string   "hint"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "fbid"
    t.string   "name"
    t.integer  "score"
    t.boolean  "online"
    t.datetime "last_seen_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end