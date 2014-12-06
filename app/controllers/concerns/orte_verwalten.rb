module OrteVerwalten

  # Orte finden, zuordnen oder falls nötig, neu erstellen.
  # TODO: Auswahlmöglichkeit bei Mehrfachtreffern. Aktuell wird einfach der letzte genommen.
  def find_or_create_ort(ortsname)
    newort = Ort.find_by(:name => ortsname)
    if newort == nil
      a = Geokit::Geocoders::GoogleGeocoder.geocode ortsname
      a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
      newort = Ort.create(:name => ortsname, :lat => a.lat, :lon => a.lng, :plz => a.zip)
    end
    newort
  end 

end
