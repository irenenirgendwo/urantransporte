# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_02_29_092018) do

  create_table "anlagen", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ort_id"
    t.text "beschreibung"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "bild_url"
    t.string "bild_urheber"
    t.integer "anlagen_kategorie_id"
  end

  create_table "anlagen_kategorien", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "anlagen_synonyms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "anlage_id"
    t.string "synonym", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beobachtungen", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "beschreibung"
    t.integer "transportabschnitt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ankunft_zeit"
    t.datetime "abfahrt_zeit"
    t.string "verkehrstraeger"
    t.boolean "kennzeichen_radioaktiv"
    t.boolean "kennzeichen_aetzend"
    t.boolean "kennzeichen_spaltbar"
    t.boolean "kennzeichen_umweltgefaehrdend"
    t.string "fahrtrichtung"
    t.string "gefahr_nummer"
    t.string "un_nummer"
    t.string "firma_beschreibung"
    t.text "lok_beschreibung"
    t.text "container_beschreibung"
    t.integer "anzahl_container"
    t.text "zug_beschreibung"
    t.string "anzahl_lkw"
    t.string "kennzeichen_lkw"
    t.string "lkw_beschreibung"
    t.string "schiff_name"
    t.text "schiff_beschreibung"
    t.boolean "polizei"
    t.boolean "hubschrauber"
    t.boolean "foto"
    t.string "email"
    t.string "quelle"
    t.string "foto_path"
    t.string "foto_recht"
    t.text "begleitung_beschreibung"
    t.integer "schiff_id"
    t.integer "ort_id"
  end

  create_table "durchfahrtsorte", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "reihung"
    t.integer "ort_id"
    t.integer "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "firmen", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "beschreibung"
    t.string "typ"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "reederei"
  end

  create_table "orte", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "plz"
    t.float "lat"
    t.float "lon"
  end

  create_table "orte_transportabschnitte", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "ort_id"
    t.integer "transportabschnitt_id"
  end

  create_table "routen", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schiffe", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.integer "imo"
    t.integer "mmsi"
    t.string "vesselfinder_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "current_lat"
    t.float "current_lon"
    t.string "bild_url"
    t.string "bild_urheber"
    t.text "next_ports"
    t.integer "firma_id"
    t.string "current_destination"
    t.datetime "current_eta"
    t.index ["firma_id"], name: "index_schiffe_on_firma_id"
  end

  create_table "stoff_synonyms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "synonym"
    t.integer "stoff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stoffe", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "bezeichnung"
    t.text "beschreibung"
    t.string "un_nummer"
    t.string "gefahr_nummer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportabschnitte", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "transport_id"
    t.integer "firma_id"
    t.string "verkehrstraeger"
    t.datetime "start_datum"
    t.datetime "end_datum"
    t.integer "start_ort_id"
    t.integer "end_ort_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "route_id"
    t.integer "schiff_id"
    t.index ["route_id"], name: "index_transportabschnitte_on_route_id"
    t.index ["schiff_id"], name: "index_transportabschnitte_on_schiff_id"
  end

  create_table "transporte", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.date "datum", null: false
    t.integer "start_anlage_id", null: false
    t.integer "ziel_anlage_id", null: false
    t.integer "transportgenehmigung_id"
    t.decimal "menge_netto", precision: 10
    t.integer "anzahl"
    t.string "un_nummer"
    t.string "behaelter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "stoff_id"
    t.string "quelle"
    t.decimal "menge_brutto", precision: 10
  end

  create_table "transportgenehmigungen", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "lfd_nr"
    t.string "antragssteller"
    t.string "stoff"
    t.date "antragsdatum"
    t.integer "max_anzahl"
    t.boolean "schiene"
    t.boolean "strasse"
    t.boolean "see"
    t.boolean "luft"
    t.boolean "umschlag"
    t.date "erstellungsdatum"
    t.date "gueltigkeit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "umschlaege", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "ort_id"
    t.string "terminal"
    t.datetime "start_datum"
    t.datetime "end_datum"
    t.integer "firma_id"
    t.integer "transport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest"
    t.string "remember_digest"
    t.integer "role", default: 0
    t.boolean "benachrichtigung"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versandstuecke", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "container_nummer"
    t.integer "transport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "transportabschnitte", "routen"
  add_foreign_key "transportabschnitte", "schiffe"
end
