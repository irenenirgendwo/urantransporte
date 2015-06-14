# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

anlagenListe = ["Uranabbau", "Konversion", "Urananreicherung",  "Brennelementefertigung", "AKW", "Wiederaufarbeitung",  "Atommmülllager", "Dummy", "Forschung", "Sonstige", "Unbekannt"]

anlagenListe.each do |text|
  AnlagenKategorie.find_or_create_by(name: text)
end

Firma.find_or_create_by(name: "Unbekannt").update_attributes(reederei: true)
Schiff.find_or_create_by(name: "Unbekannt")
Anlage.find_or_create_by(name: "Unbekannt")
Route.find_or_create_by(name: "Unbekannt")
