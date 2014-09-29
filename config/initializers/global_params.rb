VERKEHRSTRAEGER = ["LKW", "Zug", "Schiff", "Flugzeug"]

VERKEHRSTRAEGER_COMBOBOX =  []
VERKEHRSTRAEGER.each do |kategorie|
  VERKEHRSTRAEGER_COMBOBOX << [kategorie, kategorie]
end
