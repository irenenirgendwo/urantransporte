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

ActiveRecord::Schema.define(version: 20141002194403) do

  create_table "anlagen", force: true do |t|
    t.string   "name",                 null: false
    t.string   "adresse"
    t.string   "plz"
    t.string   "ort"
    t.text     "beschreibung"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lon"
    t.string   "bild_url"
    t.string   "bild_urheber"
    t.integer  "anlagen_kategorie_id"
  end

  create_table "anlagen_kategorien", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anlagen_synonyms", force: true do |t|
    t.integer  "anlage_id"
    t.string   "synonym",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beobachtungen", force: true do |t|
    t.date     "start_datum"
    t.date     "end_datum"
    t.string   "ort"
    t.string   "geo_koordinaten"
    t.text     "beschreibung"
    t.integer  "transportabschnitt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "firmen", force: true do |t|
    t.string   "name",         null: false
    t.string   "adresse"
    t.string   "plz"
    t.string   "ort"
    t.text     "beschreibung"
    t.string   "typ"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orte", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stoff_synonyms", force: true do |t|
    t.string   "synonym"
    t.integer  "stoff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stoffe", force: true do |t|
    t.string   "bezeichnung"
    t.text     "beschreibung"
    t.string   "un_nummer"
    t.string   "gefahr_nummer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportabschnitte", force: true do |t|
    t.integer  "transport_id"
    t.integer  "firma_id"
    t.string   "verkehrstraeger"
    t.date     "start_datum"
    t.date     "end_datum"
    t.string   "start_ort"
    t.string   "end_ort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transporte", force: true do |t|
    t.date     "datum",                   null: false
    t.integer  "start_anlage_id",         null: false
    t.integer  "ziel_anlage_id",          null: false
    t.integer  "transportgenehmigung_id"
    t.decimal  "menge"
    t.integer  "anzahl"
    t.string   "un_nummer"
    t.string   "behaelter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stoff_id"
    t.string   "quelle"
  end

  create_table "transportgenehmigungen", force: true do |t|
    t.string   "lfd_nr"
    t.string   "antragssteller"
    t.string   "stoff"
    t.date     "antragsdatum"
    t.integer  "max_anzahl"
    t.boolean  "schiene"
    t.boolean  "strasse"
    t.boolean  "see"
    t.boolean  "luft"
    t.boolean  "umschlag"
    t.date     "erstellungsdatum"
    t.date     "gueltigkeit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "umschlaege", force: true do |t|
    t.string   "ort"
    t.string   "terminal"
    t.date     "start_datum"
    t.date     "end_datum"
    t.integer  "firma_id"
    t.integer  "transport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "versandstuecke", force: true do |t|
    t.string   "container_nummer"
    t.integer  "transport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
