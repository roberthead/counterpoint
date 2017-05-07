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

ActiveRecord::Schema.define(version: 20170507142309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "compositions", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", default: "C major", null: false
    t.string "meter", default: "4/4", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "identity_id", null: false
    t.index ["identity_id"], name: "index_compositions_on_identity_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name", default: ""
    t.string "oauth_token", null: false
    t.datetime "oauth_expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "voice_id", null: false
    t.integer "bar", default: 1, null: false
    t.string "pitch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voice_id"], name: "index_notes_on_voice_id"
  end

  create_table "voices", force: :cascade do |t|
    t.bigint "composition_id", null: false
    t.integer "vertical_position", default: 1, null: false
    t.boolean "cantus_firmus", default: false, null: false
    t.string "clef", default: "treble", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["composition_id"], name: "index_voices_on_composition_id"
  end

  add_foreign_key "compositions", "identities"
  add_foreign_key "notes", "voices"
  add_foreign_key "voices", "compositions"
end
