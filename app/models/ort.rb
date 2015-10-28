# encoding: utf-8
class Ort < ActiveRecord::Base

  validates :name, presence: true

  has_and_belongs_to_many :transportabschnitte
  has_many :anlagen, :dependent => :restrict_with_error
  has_many :start_transportabschnitte, :foreign_key => 'start_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :ziel_transportabschnitte, :foreign_key => 'end_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :umschlaege, :dependent => :restrict_with_error
  has_many :beobachtungen, :dependent => :restrict_with_error
  has_many :durchfahrtsorte, :dependent => :restrict_with_error
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon
  
  def to_s
    name
  end
  
  def ll
    # heißt ll, weil die entsprechende Geocode-Methode ll heißt
    lat.to_s + ',' + lon.to_s
  end
  
  def get_routen
    Route.joins(:durchfahrtsorte).where("ort_id = ?",self.id).distinct
  end
  
  # gibt ein Array aller Transporte zurueck, die ueber Abschnitte, Beobachtungen oder Umschlaege mit dem Transport verknuepft sind
  # 
  def transporte
    transporte = []
    self.start_transportabschnitte.each do |abschnitt|
      transporte << abschnitt.transport 
    end
    self.ziel_transportabschnitte.each do |abschnitt|
      transporte << abschnitt.transport 
    end
    self.umschlaege.each do |umschlag|
      transporte << umschlag.transport
    end
    self.beobachtungen.each do |beob|
      transporte << beob.transportabschnitt.transport unless beob.transportabschnitt.nil?
    end
    self.durchfahrtsorte.each do |durchfahrt|
      transporte.concat(durchfahrt.route.transporte)
    end
    transporte.uniq
  end
  
  # Gibt alle Objekte in einer Liste zurück, die mit der ort_id verknüpft sind,
  # Ausnahme sind Transportabschnitte, weil diese zwei ort_ids haben.
  #
  def objekte_mit_ort_id 
    objekte = []
    objekte.concat(self.umschlaege)
    objekte.concat(self.beobachtungen)
    objekte.concat(self.anlagen)
    objekte
  end
  
  # fuegt einen anderen Ort mit dessen Verknuepfungen diesem hinzu
  # und loescht den anderen Ort.
  # Funktionert doch, die alten Referenzen bleiben nur im Cache. Daher darauf achten, den Cache zu leeren.
  #
  def add_ort(ort)
    #File.open("log/ort.log","a"){|f| f.puts "Ort #{self.id} nimmt Ort auf #{ort.id}" }
    objektliste = ort.objekte_mit_ort_id
    objektliste.each do |objekt|
      objekt.ort = self 
      return false unless objekt.save 
    #  File.open("log/ort.log","a"){|f| f.puts "#{objekt} Ort #{objekt.ort.id}" }
    end
 
    #File.open("log/ort.log","a"){|f| f.puts "ortsobjekte #{ort.objekte_mit_ort_id}" }
    ort.start_transportabschnitte.each do |abschnitt|
      #File.open("log/ort.log","a"){|f| f.puts "#{abschnitt} old Ort #{abschnitt.start_ort.id}" }
      abschnitt.start_ort = self
      return false unless abschnitt.save
      #File.open("log/ort.log","a"){|f| f.puts "#{abschnitt} new Ort #{abschnitt.start_ort.id}" }
    end 
    ort.ziel_transportabschnitte.each do |abschnitt|
      abschnitt.end_ort = self
      return false unless abschnitt.save
    end 
    # Cache leeren
    ort.empty_cache
    return ort
  end
  
  def empty_cache
    self.anlagen(true)
    self.start_transportabschnitte(true)
    self.ziel_transportabschnitte(true)
    self.beobachtungen(true)
    self.umschlaege(true)
    self.durchfahrtsorte(true)
  end 
  
  # Gibt alle Orte, die nicht identisch sind (falls der Ort gespeichert ist) im Umrkeis von radius aus.
  #
  def orte_im_umkreis(radius)
    dort = Geokit::Geocoders::GoogleGeocoder.geocode "#{lat},#{lon}"
    if self.id
      Ort.where("id <> ?", self.id).within(radius, :origin => dort)
    else
      Ort.within(radius, :origin => dort)
    end
  end
  
  # Alle Orte, die fehlerfrei gelöscht werden können
  # (d.h. keine Referenzierungen erhalten) werden gelöscht.
  # 
  def self.loesche_ungenutzte
    anzahl = 0
    Ort.all.each do |o|
      begin
        success = o.destroy
        anzahl += 1 if success
      rescue

      end
    end
    anzahl 
  end
  
  # findet einen passenden Ort oder erstellt einen neuen, wenn es den noch nicht gibt.
  # Problem: wählt bereits einen Ort aus und ignoriert evtl. Mehrfachtreffer
  #
  def self.find_or_create_ort(ortsname, plz = nil, lat = nil, lon=nil)
    newort = Ort.find_by(:name => ortsname)
    if newort == nil
      begin
        if lat == nil || lon == nil
          a = Geokit::Geocoders::GoogleGeocoder.geocode ortsname
          a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
          lat = a.lat 
          lon = a.lng
          zip = a.zip
        end
      # Fehlerbehandlung falls Ort nicht gefunden
      rescue
        lat = nil
        lon = nil
        zip = nil
      end
      newort = Ort.create(:name => ortsname, :lat => lat, :lon => lon, :plz => zip)
    end
    newort
  end 

 
  # Grundgerüst der Ortsauswahl bei Mehrfachtreffern 
  # Idee: 
  # Als erstes wird in den vorhandenen Datensätzen gesucht.
  # Falls nichts gefunden wurde, wird mit Geokit nach Daten gesucht.
  # Wenn ein Treffer eindeutig ist wird true, der Treffer zurück gegeben.
  # 
  # Wenn es mehrere Treffer bei der Geokit-Suche gibt,
  # wird für jeden Geokit-Treffer ein Datensatz angelegt, 
  # damit aus den Ortsdatensätzen gewählt werden kann.
  #
  # In diesem Fall (oder mehrere vorhandene Datensätze gefunden wurden)
  # wird false und die Liste der Treffer zurück gegeben. 
  # 
  # Wird der Ort nicht gefunden, wird false, nil zurück gegeben.
  #
  def self.ort_waehlen(ort)
    orte = Ort.orte_mit_namen(ort)
    if orte.size > 1
      #File.open("log/ort.log","a"){|f| f.puts "Mehrere Orte gefunden" }
      return false, orte #redirect_to orte_ortswahl_path 
    elsif orte.size == 1
      #File.open("log/ort.log","a"){|f| f.puts "Einen Ort gefunden" }
      return true, orte.first
    else 
      orte =  Ort.lege_passende_orte_an(ort)
      if orte.size > 1
        #File.open("log/ort.log","a"){|f| f.puts "Mehrere Orte gefunden" }
        return false, orte
      elsif orte.size == 1
        #File.open("log/ort.log","a"){|f| f.puts "Einen Ort gefunden" }
        return true, orte.first
      elsif orte.empty?
        return false, nil
      end  
    end
  end
  
  
  
  # legt alle zu einem Ortsnamen passende Orte an.
  #
  def self.lege_passende_orte_an ort
    angelegte_orte = []
    begin
      orte =  Geokit::Geocoders::GoogleGeocoder.geocode ort
      orte.all.each do |o|
        o =  Geokit::Geocoders::GoogleGeocoder.geocode o.ll
        unless o.city.nil? && o.zip.nil? && o.lat.nil? && o.lng.nil?
          o = Ort.create(:name => o.city, :plz => o.zip, :lat => o.lat, :lon => o.lng)
          angelegte_orte << o
          #File.open("log/ort.log","a"){|f| f.puts "Ort angelegt: #{o.attributes}" }
        end
      end
    rescue
      # Wenn ein Fehler auftritt (beim Geocoder durchaus moeglich) einfach nur die bis dahin erzeugte Liste zurueck geben
    end
    angelegte_orte
  end
  
  # Suche nach Orten: Gibt passende Orte als Array zurück.
  #
  def self.orte_mit_namen ort
    # ort in einzelne Worte zerlegen und (verfeinernd einzeln) suchen.
    # damit z.B. "Königstein Taunus" auch "Königstein im Taunus" findet
    # Teiltreffer werden nicht berücksichtigt.
    # "Gronau Westf" findet so auch "Gronau (Westf)" aber nicht "Gronau"
    ort.gsub!(/[^\w\däöüÄÖÜß]/, " ");
    # \W würde auch Umlaute wegschmeißen, was zu unerwarteten Suchergebnissen im ggf. anschließenden geocode verursacht.
    # Sonderzeichen wegschmeißen für bessere Suchergebnisse: "Gronau (Westf)" == "Gronau/Westf" == "Gronau Westf"
    worte = ort.split(" ")
    m_orte = Ort.all
    worte.each do |w|
      m_orte = m_orte.where("name LIKE ?","%#{w}%")
    end
    m_orte.to_a
   # Ort.where("name LIKE ?","%#{ort}%").to_a
  end
  
  
  # Erzeugt einen Ort nur mit Koordinatenangaben
  #
  def self.create_by_koordinates(lat,lon)
    #File.open("log/ort.log","a"){|f| f.puts "create ort by koordinates lat: #{lat}" }
    ort = Ort.find_by(lat: lat, lon: lon)
    if ort.nil?
      begin
        #File.open("log/ort.log","a"){|f| f.puts "create ort by koordinates" }
        o = Geokit::Geocoders::GoogleGeocoder.geocode "#{lat},#{lon}"
        ort = create(:name => o.city, :lat => lat, :lon => lon, :plz => o.zip)
      rescue 
        o = Geokit::Geocoders::GoogleGeocoder.geocode "#{lat},#{lon}"
        ort = create(:name => o.city, :lat => lat, :lon => lon, :plz => o.zip)
      end
      #File.open("log/ort.log","a"){|f| f.puts "Erzeugter Ort: #{ort.attributes}" }
    end 
    ort
  end
  
  def self.create_by_koordinates_and_name(name, lat, lon)
    #File.open("log/ort.log","a"){|f| f.puts "create ort by name #{name} koordinates #{lat},#{lon}" }
    if lat && lon
      ort = Ort.create_by_koordinates(lat,lon)
      ort.update(:name => name) unless name.nil? or name == ""
    else 
      ort = Ort.find_or_create_ort(name)
    end
    #File.open("log/ort.log","a"){|f| f.puts "Ort #{ort}" }
    ort
  end
  
end
