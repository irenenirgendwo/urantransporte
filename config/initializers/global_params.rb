VERKEHRSTRAEGER = {1 => "LKW", 2 => "Zug", 3 => "Schiff", 4 => "Flugzeug"}

VERKEHRSTRAEGER_COMBOBOX =  Hash.new
VERKEHRSTRAEGER.each do |key, kategorie|
  VERKEHRSTRAEGER_COMBOBOX[kategorie] = key
end
