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

ActiveRecord::Schema.define(version: 20140910215853) do

  create_table "anlagen", force: true do |t|
    t.string   "name"
    t.string   "adresse"
    t.string   "plz"
    t.string   "ort"
    t.text     "beschreibung"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lon"
  end

  create_table "anlagen_synonyms", force: true do |t|
    t.integer  "anlage_id"
    t.string   "synonym"
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
    t.string   "name"
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
    t.date     "datum"
    t.integer  "start_anlage_id"
    t.integer  "ziel_anlage_id"
    t.integer  "transportgenehmigung_id"
    t.decimal  "menge"
    t.integer  "anzahl"
    t.string   "stoff"
    t.string   "un_nummer"
    t.string   "behaelter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportgenehmigungen", force: true do |t|
    t.string   "lfd_nr"
    t.string   "antragssteller"
    t.string   "stoff"
    t.date     "antragsdatum"
    t.integer  "max_anzahl"
    t.boolean  "schiene"
    t.boolean  "strasse"
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

  create_table "versandstuecke", force: true do |t|
    t.string   "container_nummer"
    t.integer  "transport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
