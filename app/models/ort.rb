# encoding: utf-8
class Ort < ActiveRecord::Base
  has_and_belongs_to_many :transportabschnitte
  has_many :anlagen, :dependent => :restrict_with_error
  has_many :start_transportabschnitte, :foreign_key => 'start_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :ziel_transportabschnitte, :foreign_key => 'ziel_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :umschlaege
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon
  
  def to_s
    name
  end
  
  def ll
    lat.to_s + ',' + lon.to_s
  end
  
  # findet einen passenden Ort oder erstellt einen neuen, wenn es den noch nicht gibt.
  #
  def self.find_or_create_ort(ortsname)
    newort = Ort.find_by(:name => ortsname)
    if newort == nil
      a = Geokit::Geocoders::GoogleGeocoder.geocode ortsname
      a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
      newort = Ort.create(:name => ortsname, :lat => a.lat, :lon => a.lng, :plz => a.zip)
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
      File.open("log/ort.log","a"){|f| f.puts "Mehrere Orte gefunden" }
      return false, orte #redirect_to orte_ortswahl_path 
    elsif orte.size == 1
      File.open("log/ort.log","a"){|f| f.puts "Einen Ort gefunden" }
      return true, orte.first
    else 
      orte =  Ort.lege_passende_orte_an(ort)
      if orte.size > 1
        File.open("log/ort.log","a"){|f| f.puts "Mehrere Orte gefunden" }
        return false, orte
      elsif orte.size == 1
        File.open("log/ort.log","a"){|f| f.puts "Einen Ort gefunden" }
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
    orte =  Geokit::Geocoders::GoogleGeocoder.geocode ort
    orte.all.each do |o|
      o =  Geokit::Geocoders::GoogleGeocoder.geocode o.ll
      o = Ort.create(:name => o.city, :plz => o.zip, :lat => o.lat, :lon => o.lng)
      angelegte_orte << o
      File.open("log/ort.log","a"){|f| f.puts "Ort angelegt: #{o.attributes}" }
    end
    angelegte_orte
  end
  
  # gibt passende Orte als Array zurück.
  def self.orte_mit_namen ort
    Ort.where(:name => ort).to_a
  end
  
  def self.create_by_koordinates(lat,lon)
    File.open("log/ort.log","a"){|f| f.puts "create ort by koordinates" }
    ort = Ort.find_by(lat: lat, lon: lon)
    if ort.nil?
      File.open("log/ort.log","a"){|f| f.puts "create ort by koordinates" }
      o = Geokit::Geocoders::GoogleGeocoder.geocode "#{lat},#{lon}"
      ort = create(:name => o.city, :lat => lat, :lon => lon, :plz => o.zip)
      File.open("log/ort.log","a"){|f| f.puts "Erzeugter Ort: #{ort.attributes}" }
    end 
    ort
  end
  
end
