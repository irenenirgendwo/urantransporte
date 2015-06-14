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

ActiveRecord::Schema.define(version: 20150614145109) do

  create_table "anlagen", force: :cascade do |t|
    t.string   "name",                 limit: 255,   null: false
    t.integer  "ort_id",               limit: 4
    t.text     "beschreibung",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bild_url",             limit: 255
    t.string   "bild_urheber",         limit: 255
    t.integer  "anlagen_kategorie_id", limit: 4
  end

  create_table "anlagen_kategorien", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anlagen_synonyms", force: :cascade do |t|
    t.integer  "anlage_id",  limit: 4
    t.string   "synonym",    limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beobachtungen", force: :cascade do |t|
    t.text     "beschreibung",                  limit: 65535
    t.integer  "transportabschnitt_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ankunft_zeit"
    t.datetime "abfahrt_zeit"
    t.string   "verkehrstraeger",               limit: 255
    t.boolean  "kennzeichen_radioaktiv",        limit: 1
    t.boolean  "kennzeichen_aetzend",           limit: 1
    t.boolean  "kennzeichen_spaltbar",          limit: 1
    t.boolean  "kennzeichen_umweltgefaehrdend", limit: 1
    t.string   "fahrtrichtung",                 limit: 255
    t.string   "gefahr_nummer",                 limit: 255
    t.string   "un_nummer",                     limit: 255
    t.string   "firma_beschreibung",            limit: 255
    t.text     "lok_beschreibung",              limit: 65535
    t.text     "container_beschreibung",        limit: 65535
    t.integer  "anzahl_container",              limit: 4
    t.text     "zug_beschreibung",              limit: 65535
    t.string   "anzahl_lkw",                    limit: 255
    t.string   "kennzeichen_lkw",               limit: 255
    t.string   "lkw_beschreibung",              limit: 255
    t.string   "schiff_name",                   limit: 255
    t.text     "schiff_beschreibung",           limit: 65535
    t.boolean  "polizei",                       limit: 1
    t.boolean  "hubschrauber",                  limit: 1
    t.boolean  "foto",                          limit: 1
    t.string   "email",                         limit: 255
    t.string   "quelle",                        limit: 255
    t.string   "foto_path",                     limit: 255
    t.string   "foto_recht",                    limit: 255
    t.text     "begleitung_beschreibung",       limit: 65535
    t.integer  "schiff_id",                     limit: 4
    t.integer  "ort_id",                        limit: 4
  end

  create_table "durchfahrtsorte", force: :cascade do |t|
    t.integer  "index",      limit: 4
    t.integer  "ort_id",     limit: 4
    t.integer  "route_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "firmen", force: :cascade do |t|
    t.string   "name",         limit: 255,   null: false
    t.text     "beschreibung", limit: 65535
    t.string   "typ",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reederei",     limit: 1
  end

  create_table "orte", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.string   "plz",        limit: 255
    t.float    "lat",        limit: 24
    t.float    "lon",        limit: 24
  end

  create_table "orte_transportabschnitte", force: :cascade do |t|
    t.integer "ort_id",                limit: 4
    t.integer "transportabschnitt_id", limit: 4
  end

  create_table "routen", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "schiffe", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "imo",                 limit: 4
    t.integer  "mmsi",                limit: 4
    t.string   "vesselfinder_url",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "current_lat",         limit: 24
    t.float    "current_lon",         limit: 24
    t.string   "bild_url",            limit: 255
    t.string   "bild_urheber",        limit: 255
    t.text     "next_ports",          limit: 65535
    t.integer  "firma_id",            limit: 4
    t.string   "current_destination", limit: 255
    t.datetime "current_eta"
  end

  add_index "schiffe", ["firma_id"], name: "index_schiffe_on_firma_id", using: :btree

  create_table "stoff_synonyms", force: :cascade do |t|
    t.string   "synonym",    limit: 255
    t.integer  "stoff_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stoffe", force: :cascade do |t|
    t.string   "bezeichnung",   limit: 255
    t.text     "beschreibung",  limit: 65535
    t.string   "un_nummer",     limit: 255
    t.string   "gefahr_nummer", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportabschnitte", force: :cascade do |t|
    t.integer  "transport_id",    limit: 4
    t.integer  "firma_id",        limit: 4
    t.string   "verkehrstraeger", limit: 255
    t.datetime "start_datum"
    t.datetime "end_datum"
    t.integer  "start_ort_id",    limit: 4
    t.integer  "end_ort_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "route_id",        limit: 4
  end

  add_index "transportabschnitte", ["route_id"], name: "index_transportabschnitte_on_route_id", using: :btree

  create_table "transporte", force: :cascade do |t|
    t.date     "datum",                                              null: false
    t.integer  "start_anlage_id",         limit: 4,                  null: false
    t.integer  "ziel_anlage_id",          limit: 4,                  null: false
    t.integer  "transportgenehmigung_id", limit: 4
    t.decimal  "menge_netto",                         precision: 10
    t.integer  "anzahl",                  limit: 4
    t.string   "un_nummer",               limit: 255
    t.string   "behaelter",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stoff_id",                limit: 4
    t.string   "quelle",                  limit: 255
    t.decimal  "menge_brutto",                        precision: 10
  end

  create_table "transportgenehmigungen", force: :cascade do |t|
    t.string   "lfd_nr",           limit: 255
    t.string   "antragssteller",   limit: 255
    t.string   "stoff",            limit: 255
    t.date     "antragsdatum"
    t.integer  "max_anzahl",       limit: 4
    t.boolean  "schiene",          limit: 1
    t.boolean  "strasse",          limit: 1
    t.boolean  "see",              limit: 1
    t.boolean  "luft",             limit: 1
    t.boolean  "umschlag",         limit: 1
    t.date     "erstellungsdatum"
    t.date     "gueltigkeit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "umschlaege", force: :cascade do |t|
    t.integer  "ort_id",       limit: 4
    t.string   "terminal",     limit: 255
    t.datetime "start_datum"
    t.datetime "end_datum"
    t.integer  "firma_id",     limit: 4
    t.integer  "transport_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
    t.integer  "role",            limit: 4,   default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versandstuecke", force: :cascade do |t|
    t.string   "container_nummer", limit: 255
    t.integer  "transport_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "transportabschnitte", "routen"
end
