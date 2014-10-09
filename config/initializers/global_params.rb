VERKEHRSTRAEGER = ["LKW", "Zug", "Schiff", "Flugzeug", "unbekannt"]

VERKEHRSTRAEGER_COMBOBOX =  []
VERKEHRSTRAEGER.each do |kategorie|
  VERKEHRSTRAEGER_COMBOBOX << [kategorie, kategorie]
end
